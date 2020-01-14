//
//  TradingViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingViewController: ListViewController {
    typealias ViewModel = TradingViewModel
    
    // MARK: - Veriables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    let titleView = TitleView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    
    // MARK: - Methods
    private func setup() {
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        dataSource.delegate = self
        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
        
        titleView.titleLabel.text = "Trading"
        titleView.balanceLabel.text = viewModel.getTotalValue()
        
        navigationItem.titleView = titleView
    }
    
    private func createFund() {
        guard let vc = CreateFundViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create Fund"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func createAccount() {
        guard let vc = CreateAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func attachAccount() {
        guard let vc = AttachAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Attach account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func addAccountSelector() {
        showActionSheet(with: nil,
                        message: nil,
                        firstActionTitle: "Create account",
                        firstHandler: { [weak self] in
                            self?.createAccount()
            },
                        secondActionTitle: "Attach account",
                        secondHandler: { [weak self] in
                            self?.attachAccount()
            },
                        cancelTitle: "Cancel",
                        cancelHandler: nil)
    }
    func showEvent(_ event: InvestmentEventViewModel) {
        var count = 0

        if let extendedInfo = event.extendedInfo, !extendedInfo.isEmpty {
            count += extendedInfo.count
        }

        if let fees = event.feesInfo, !fees.isEmpty {
            count += fees.count + 1
        }

        let height = Double((count + 1) * 40)

        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = CGFloat(230.0 + height)
        bottomSheetController.lineViewIsHidden = true

        let view = EventDetailsView.viewFromNib()
        view.configure(event)
        view.delegate = self
        bottomSheetController.addContentsView(view)
        bottomSheetController.present()
    }
}

extension TradingViewController: DelegateManagerProtocol {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
}
extension TradingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleView.animate(scrollView.contentOffset.y)
    }
}
extension TradingViewController: BaseTableViewProtocol {
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .tradingEvents:
            let vc = TradingEventListViewController()
            viewModel.router?.tradingEventListViewController = vc
            vc.viewModel = TradingEventListViewModel(viewModel.router, delegate: vc)
            vc.title = "Events"
            navigationController?.pushViewController(vc, animated: true)
        case .tradingPublicList:
            switch actionType {
            case .showAll:
                let vc = TradingPublicListViewController()
                vc.viewModel = TradingPublicListViewModel(viewModel.router, delegate: vc)
                vc.title = "Public"
                navigationController?.pushViewController(vc, animated: true)
            case .add:
                self.createFund()
            default:
                break
            }
        case .tradingPrivateList:
            switch actionType {
            case .showAll:
                let vc = TradingPrivateListViewController()
                vc.viewModel = TradingPrivateListViewModel(viewModel.router, delegate: vc)
                vc.title = "Private"
                navigationController?.pushViewController(vc, animated: true)
            case .add:
                self.addAccountSelector()
            default:
                break
            }
        default:
            break
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingEvents:
            if let viewModel = cellViewModel as? PortfolioEventCollectionViewCellViewModel {
                self.showEvent(viewModel.event)
            }
        case .tradingPublicList:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel {
                showAsset(cellViewModel)
            }
        case .tradingPrivateList:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel, cellViewModel.type == ._none, let tradingAsset = cellViewModel.asset.tradingAsset {
                showAccount(tradingAsset)
            }
        default:
            break
        }
    }
    
    func showAsset(_ asset: AssetCollectionViewCellViewModel) {
        var assetId = ""
        let type = asset.type
        
        switch type {
        case .program:
            if let program = asset.asset.program {
                assetId = program.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case .fund:
            if let fund = asset.asset.fund {
                assetId = fund.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case .follow:
            if let follow = asset.asset.follow {
                assetId = follow.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case ._none:
            break
        }
        
        if !assetId.isEmpty {
            viewModel.router?.showAssetDetails(with: assetId, assetType: type)
        }
    }
    func showAccount(_ tradingAsset: DashboardTradingAsset) {
        if let router = viewModel.router, let assetId = tradingAsset.id?.uuidString {
            let viewController = AccountViewController()
            let accountRouter = AccountRouter(parentRouter: router)
            viewController.viewModel = AccountTabmanViewModel(withRouter: accountRouter, assetId: assetId)
            navigationController?.pushViewController(viewController, animated: true)
       }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleView.balanceLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension TradingViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.didSelectEvent(at: assetId, assetType: assetType)
    }
}

class TradingViewModel: ViewModelWithListProtocol {
    enum RowType {
        case overview
        case events
        case publicTrading
        case privateTrading
    }
    private var rows: [RowType] = [.overview, .publicTrading, .privateTrading]
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingHeaderTableViewCellViewModel.self,
                CellWithCollectionViewModel<TradingEventsViewModel>.self,
                CellWithCollectionViewModel<TradingPublicShortListViewModel>.self,
                CellWithCollectionViewModel<TradingPrivateShortListViewModel>.self]
    }
    var details: DashboardTradingDetails? {
        didSet {
            let overviewViewModel = TradingHeaderTableViewCellViewModel(data: TradingHeaderData(details: details, currency: currency), delegate: delegate)
            viewModels.append(overviewViewModel)
            reloadRow(.events)
            
            guard let count = details?.events?.items?.count, count > 0 else { return }
            
            rows.insert(.events, at: 1)
            let eventsViewModel = CellWithCollectionViewModel(TradingEventsViewModel(details, delegate: delegate), delegate: delegate)
            viewModels.append(eventsViewModel)
            delegate?.didReload()
        }
    }
    var publicTrading: ItemsViewModelDashboardTradingAsset? {
        didSet {
            guard let count = publicTrading?.items?.count, count > 0 else { return }
            let viewModel = CellWithCollectionViewModel(TradingPublicShortListViewModel(publicTrading, delegate: delegate, router: router), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.publicTrading)
        }
    }
    var privateTrading: ItemsViewModelDashboardTradingAsset? {
        didSet {
            guard let count = privateTrading?.items?.count, count > 0 else { return }
            let viewModel = CellWithCollectionViewModel(TradingPrivateShortListViewModel(privateTrading, delegate: delegate, router: router), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.privateTrading)
        }
    }
    
    lazy var currency = getPlatformCurrencyType()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var router: DashboardRouter?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: DashboardRouter?) {
        self.delegate = router?.tradingViewController
        self.router = router
    }
    private func reloadRow(_ row: RowType) {
        delegate?.didReload(IndexPath(row: rows.firstIndex(of: row) ?? 0, section: 0))
    }
    func getTotalValue() -> String {
        if let total = details?.equity {
            return total.toString() + " " + currency.rawValue
        }
        
        return ""
    }
    func fetch() {
        viewModels.removeAll()
    
        DashboardDataProvider.getTrading(currency, eventsTake: 12, completion: { [weak self] (model) in
            self?.details = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getPrivateTrading(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.privateTrading = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getPublicTrading(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.publicTrading = model
        }, errorCompletion: errorCompletion)
        
        delegate?.didReload()
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = rows[indexPath.row]
        switch type {
        case .overview:
            return viewModels.first{ $0 is TradingHeaderTableViewCellViewModel }
        case .events:
            return viewModels.first{ $0 is CellWithCollectionViewModel<TradingEventsViewModel> }
        case .publicTrading:
            return viewModels.first{ $0 is CellWithCollectionViewModel<TradingPublicShortListViewModel> }
        case .privateTrading:
            return viewModels.first{ $0 is CellWithCollectionViewModel<TradingPrivateShortListViewModel> }
        }
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
    func modelsCount() -> Int {
        return rows.count
    }
    
}

