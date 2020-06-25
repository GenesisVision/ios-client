//
//  FundViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class FundViewController: BaseTabmanViewController<FundViewModel> {
    // MARK: - View Model
    weak var fundInfoViewControllerProtocol: FavoriteStateChangeProtocol?

    private var favoriteBarButtonItem: UIBarButtonItem!
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setup()
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            self?.reloadData()
            self?.title = self?.viewModel.title
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        guard AuthManager.isLogin() else { return }
        
        if let isFavorite = self.viewModel?.isFavorite {
            favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(favoriteButtonAction))
        }
        
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, notificationsBarButtonItem]
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationSettings()
    }
    
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        setupUI()
    }
    
    // MARK: - IBActions
    @objc func favoriteButtonAction() {
        guard let isFavorite = self.viewModel?.isFavorite else { return }
        self.favoriteBarButtonItem.image = !isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        
        showProgressHUD()
        self.viewModel?.changeFavorite(value: isFavorite, request: true) { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                self?.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

extension FundViewController: ReloadDataProtocol {
    func didReloadData() {
    }
}
extension FundViewController: FavoriteStateUpdatedProtocol {
    func didFavoriteStateUpdated() {
        DispatchQueue.main.async {
            guard AuthManager.isLogin() else { return }
            guard let isFavorite = self.viewModel?.isFavorite else { return }
            
            guard self.favoriteBarButtonItem != nil else {
                self.favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(self.favoriteButtonAction))
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonItem]
                return
            }
            
            self.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        }
    }
}

final class FundViewModel: TabmanViewModel {
    enum TabType: String {
        case info = "Info"
        
        case profit = "Profit"
        case balance = "Balance"
        
        case assets = "Assets"
        case reallocateHistory = "Reallocate history"
        
        case events = "Fund history"
    }
    var tabTypes: [TabType] = [.info, .assets, .reallocateHistory, .profit, .balance, .events]
    var controllers = [TabType : UIViewController]()
    
    // MARK: - Variables
    var assetId: String?
    
    public private(set) var tradingAccounts: TradingAccountDetailsItemsViewModel?
    public private(set) var signalSubscription: SignalSubscription?
    var fundDetailsFull: FundDetailsFull? {
        didSet {
            guard let details = fundDetailsFull else { return }
            title = details.publicInfo?.title ?? ""
        }
    }
    
    var isFavorite: Bool {
        return fundDetailsFull?.personalDetails?.isFavorite ?? false
    }
    weak var favoriteStateUpdatedProtocol: FavoriteStateUpdatedProtocol?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.assetId = assetId
        self.title = ""
        
        font = UIFont.getFont(.semibold, size: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        guard let router = router as? FundRouter, let assetId = self.assetId else { return nil }
        
        switch type {
        case .info:
            return router.getInfo(with: assetId)
        case .balance:
            let viewModel = FundBalanceViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.fundViewController)
            
            return router.getBalanceViewController(with: viewModel)
        case .profit:
            let viewModel = FundProfitViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.fundViewController, currency: getPlatformCurrencyType())
            
            return router.getProfitViewController(with: viewModel)
        case .reallocateHistory:
            return router.getReallocateHistory(with: assetId)
        case .assets:
            return router.getAssets(with: assetId)
        case .events:
            return router.getEvents(with: assetId)
        }
    }
}
extension FundViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index])
    }
}
// MARK: - Actions
extension FundViewModel {
    // MARK: - Public methods
    func showNotificationSettings() {
       router.showAssetNotificationsSettings(assetId, title: fundDetailsFull?.publicInfo?.title ?? "Fund Settings", type: .fund)
    }
    
    func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return }

        FundsDataProvider.get(assetId, currencyType: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.fundDetailsFull = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func changeFavorite(value: Bool? = nil, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            fundDetailsFull?.personalDetails?.isFavorite = value
            return completion(.success)
        }
        
        guard
            let personalDetails = fundDetailsFull?.personalDetails,
            let isFavorite = personalDetails.isFavorite,
            let assetId = assetId
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsDataProvider.favorites(isFavorite: isFavorite, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                self?.fundDetailsFull?.personalDetails?.isFavorite = !isFavorite
            case .failure(let errorType):
                print(errorType)
                self?.fundDetailsFull?.personalDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
    
    // MARK: - Private methods
    @objc private func fundFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["fundId"] as? String, assetId == self.assetId {
            changeFavorite(value: isFavorite) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}
