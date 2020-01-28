//
//  TradingPublicListViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPublicListViewController: ListViewController {
    typealias ViewModel = TradingPublicListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    private var addNewBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.refresh()
    }
    // MARK: - Methods
    private func setup() {
        addNewBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_add_photo_icon"), style: .done, target: self, action: #selector(addNewButtonAction))
        navigationItem.rightBarButtonItems = [addNewBarButtonItem]
        
        isEnableInfiniteIndicator = true
        tableView.configure(with: .defaultConfiguration)

        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
    }
    
    @objc private func addNewButtonAction() {
        guard let vc = CreateFundViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create Fund"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showAsset(_ asset: TradingTableViewCellViewModel) {
        guard let assetId = asset.asset.id?.uuidString, let type = asset.asset.assetType else { return }
        viewModel.router?.showAssetDetails(with: assetId, assetType: type)
    }
}

extension TradingPublicListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingPublicList:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                showAsset(cellViewModel)
            }
        case .makeSignal:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                makeSignal(cellViewModel.asset)
            }
        case .makeProgram:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                makeProgram(cellViewModel.asset)
            }
        case .closePeriod:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                closePeriod(cellViewModel.asset)
            }
        default:
            break
        }
    }
}

// MARK: - Actions
extension TradingPublicListViewController {
    private func makeProgram(_ asset: DashboardTradingAsset) {
        guard let vc = MakeProgramViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make program"
        vc.viewModel.request.id = asset.id
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func makeSignal(_ asset: DashboardTradingAsset) {
        guard let vc = MakeSignalViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make signal"
        vc.viewModel.request.id = asset.id
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func changePassword(_ asset: DashboardTradingAsset) {
        //TODO:
    }
    private func openSettings(_ asset: DashboardTradingAsset) {
        //TODO:
    }
    private func closePeriod(_ asset: DashboardTradingAsset) {
        guard let assetId = asset.id?.uuidString else { return }
        let model = TradingAccountPwdUpdate(password: nil, twoFactorCode: nil)
        showProgressHUD()
        AssetsDataProvider.closeCurrentPeriod(assetId, model: model) { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

class TradingPublicListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingTableViewCellViewModel.self]
    }
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [TradingTableViewCellViewModel]()
        DashboardDataProvider.getPublicTrading(currency: currency, status: .all, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                let viewModel = TradingTableViewCellViewModel(asset: asset, delegate: nil)
                models.append(viewModel)
            })
            self?.updateViewModels(models, refresh: refresh, total: model.total)
            }, errorCompletion: errorCompletion)
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        skip += take()
        viewModels = refresh ? models : viewModels + models
        delegate?.didReload()
    }
    
    func cellAnimations() -> Bool {
        return true
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.tradingPublicList, cellViewModel: model(for: indexPath))
    }
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        guard let model = model(for: indexPath) as? TradingTableViewCellViewModel,
            let assetType = model.asset.assetType,
            let actions = model.asset.actions else { return nil }
        
        var children = [UIAction]()
        
        if let name = model.asset.publicInfo?.url {
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                let url = getRoute(assetType, name: name)
                self?.router?.share(url)
            }
            children.append(share)
        }
        
        if let assetType = model.asset.assetType, assetType == .program {
            let closePeriod = UIAction(title: "Close period", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.closePeriod, cellViewModel: model)
            }
            children.append(closePeriod)
        }
        
        if let canMakeProgramFromSignalProvider = actions.canMakeProgramFromSignalProvider, canMakeProgramFromSignalProvider {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.makeProgram, cellViewModel: model)
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromProgram = actions.canMakeSignalProviderFromProgram, canMakeSignalProviderFromProgram {
            let makeSignal = UIAction(title: "Make a signal provider", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.makeSignal, cellViewModel: model)
            }
            children.append(makeSignal)
        }
        
        if let canChangePassword = actions.canChangePassword, canChangePassword {
            let changePassword = UIAction(title: "Change password", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.changePassword, cellViewModel: model)
            }
            children.append(changePassword)
        }
        
        let settings = UIAction(title: "Settings", image: nil) { [weak self] action in
            self?.delegate?.didSelect(.openSettings, cellViewModel: model)
        }
        children.append(settings)
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}
