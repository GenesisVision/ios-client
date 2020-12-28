//
//  ProgramViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ProgramViewController: BaseTabmanViewController<ProgramViewModel> {
    // MARK: - View Model
    weak var programInfoViewControllerProtocol: FavoriteStateChangeProtocol?

    private var favoriteBarButtonItem: UIBarButtonItem!
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotification(notification:)), name: .updateProgramViewController, object: nil)
        
        setupUI()
    }
    
    private func fetch() {
        showProgressHUD()
        viewModel.fetch { [weak self] (result) in
            self?.setup()
            self?.hideHUD()
            self?.reloadData()
            self?.title = self?.viewModel.title
        }
    }
    
    private func setupUI() {
        guard AuthManager.isLogin() else { return }
        
        if let isFavorite = self.viewModel?.isFavorite {
            favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(favoriteButtonAction))
        }
        
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, notificationsBarButtonItem]
    }
    
    @objc private func updateNotification(notification: Notification) {
        guard let assetId = notification.userInfo?["assetId"] as? String, assetId == viewModel.assetId else { return }
        fetch()
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationSettings()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateProgramViewController, object: nil)
    }
}

extension ProgramViewController: ReloadDataProtocol {
    func didReloadData() {
        
    }
}
extension ProgramViewController: FavoriteStateUpdatedProtocol {
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

final class ProgramViewModel: TabmanViewModel {
    enum TabType: String {
        case info = "Info"
        case profit = "Profit"
        case balance = "Balance"
        case trades = "Trades"
        case openPosition = "Open position"
        case periodHistory = "Period history"
        case events = "My history"
    }
    var tabTypes: [TabType] = []
    var controllers = [TabType : UIViewController]()
    
    // MARK: - Variables
    var assetId: String?
    var assetType: AssetType = .program
    
    public private(set) var tradingAccounts: TradingAccountDetailsItemsViewModel?
    public private(set) var signalSubscription: SignalSubscription?
    
    var programDetailsFull: ProgramFollowDetailsFull? {
        didSet {
            if programDetailsFull?.programDetails != nil {
                title = programDetailsFull?.publicInfo?.title ?? ""
                tabTypes = [.info, .profit, .balance, .trades, .openPosition, .periodHistory, .events]
            } else if programDetailsFull?.followDetails != nil {
                title = programDetailsFull?.publicInfo?.title ?? ""
                tabTypes = [.info, .profit, .balance, .trades, .openPosition, .events]
            }
            setViewControllers()
        }
    }
    
    var showEvents: Bool = true {
        didSet {
            if !showEvents {
                tabTypes.removeAll(where: { $0 == .events })
                setViewControllers()
                reloadDataProtocol?.didReloadData()
            }
        }
    }
    
    var isFavorite: Bool {
        return programDetailsFull?.programDetails?.personalDetails?.isFavorite ?? false
    }
    weak var favoriteStateUpdatedProtocol: FavoriteStateUpdatedProtocol?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        self.assetId = assetId
        self.title = ""
        
        font = UIFont.getFont(.semibold, size: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
        
        self.dataSource = PageboyDataSource(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
    }
    
    private func setViewControllers() {
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        let currency = getPlatformCurrencyType()
        
        guard let router = router as? ProgramRouter, let assetId = self.assetId else { return nil }
        
        switch type {
        case .info:
            return router.getInfo(with: assetId)
        case .balance:
            let viewModel = ProgramBalanceViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.programViewController)
            let viewController = router.getBalanceViewController(with: viewModel)
            router.programBalanceViewController = viewController
            return viewController
        case .profit:
            guard let currency = programDetailsFull?.tradingAccountInfo?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) else { return nil }
            let viewModel = ProgramProfitViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.programViewController, currency: currencyType, programType: programDetailsFull?.brokerDetails?.type)
            let viewController = router.getProfitViewController(with: viewModel)
            router.programProfitViewController = viewController
            return viewController
        case .periodHistory:
            guard let currency = programDetailsFull?.tradingAccountInfo?.currency else { return nil }
            return router.getPeriodHistory(with: assetId, currency: currency)
        case .trades:
            return router.getTrades(with: assetId, currencyType: currency)
        case .openPosition:
            return router.getTradesOpen(with: assetId, currencyType: currency)
        case .events:
            return router.getEvents(with: assetId)
        }
    }
}
extension ProgramViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        if let tabType = tabTypes[safe: index] {
            return getViewController(tabType)
        } else {
            return nil
        }
    }
}
// MARK: - Actions
extension ProgramViewModel {
    // MARK: - Public methods
    func showNotificationSettings() {
        //FIXME: program or follow
        router.showAssetNotificationsSettings(assetId, title: programDetailsFull?.publicInfo?.title ?? "Program Settings", type: .program)
    }
    
    func showAboutLevels() {
        guard let rawValue = programDetailsFull?.tradingAccountInfo?.currency?.rawValue, let currency = CurrencyType(rawValue: rawValue) else { return }
        
        router.showAboutLevels(currency)
    }
    
    func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return }
        switch assetType {
        case .program:
            ProgramsDataProvider.get(assetId, completion: { [weak self] (viewModel) in
                guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                self?.programDetailsFull = viewModel
                self?.fetchHistory(completion)
            }, errorCompletion: completion)
        case .follow:
            FollowsDataProvider.get(assetId, completion: { [weak self] (viewModel) in
                guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                self?.programDetailsFull = viewModel
                self?.fetchHistory(completion)
            }, errorCompletion: completion)
        default:
            break
        }
        
    }
    
    private func fetchHistory(_ completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return }
        
        EventsDataProvider.get(assetId, eventLocation: .asset, from: nil, to: nil, eventType: .all, assetType: .fund, assetsIds: nil, forceFilterByIds: nil, eventGroup: .none, skip: 0, take: 12, completion: { [weak self] (model) in
            guard let model = model else {
                self?.showEvents = false
                completion(.success)
                return }
            if let count = model.events?.count, count > 0 {
                self?.showEvents = true
                completion(.success)
            } else {
                self?.showEvents = false
                completion(.success)
            }
            }, errorCompletion: { (result) in
                switch result {
                    
                case .success:
                    self.showEvents = false
                    completion(.success)
                case .failure(errorType: _):
                    self.showEvents = false
                    completion(.success)
                }
            })
    }
    
    func changeFavorite(value: Bool? = nil, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            programDetailsFull?.programDetails?.personalDetails?.isFavorite = value
            return completion(.success)
        }
        
        guard
            let personalProgramDetails = programDetailsFull?.programDetails?.personalDetails,
            let isFavorite = personalProgramDetails.isFavorite,
            let assetId = assetId
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsDataProvider.favorites(isFavorite: isFavorite, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                self?.programDetailsFull?.programDetails?.personalDetails?.isFavorite = !isFavorite
            case .failure(let errorType):
                print(errorType)
                self?.programDetailsFull?.programDetails?.personalDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["programId"] as? String, assetId == self.assetId {
            changeFavorite(value: isFavorite) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}
