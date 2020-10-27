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

        viewModel.dataSource.delegate = self
        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        isEnablePullToRefresh = false
        
        titleView.titleLabel.text = "Trading"
        titleView.balanceLabel.text = viewModel.getTotalValue()
        
        navigationItem.titleView = titleView
    }
    
    @objc private func createNewFund() {
        self.dismiss(animated: true) {
            guard let viewController = FundPublicInfoViewController.storyboardInstance(.fund) else { return }
            viewController.title = "Create Fund"
            viewController.viewModel = FundPublicInfoViewModel(mode: .create)
            self.navigationController?.pushViewController(viewController, animated: true)
//            let nav = BaseNavigationController(rootViewController: viewController)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true, completion: nil)
//            guard let vc = CreateFundViewController.storyboardInstance(.dashboard) else { return }
//            vc.title = "Create Fund"
//            vc.viewModel = CreateFundViewModel(vc, addAssetsProtocol: vc)
//            let nav = BaseNavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func showCreateFundBottomSheet() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = CGFloat(view.height*0.15)
        
        let actionLabel = TitleLabel()
        
        actionLabel.font = UIFont.getFont(.regular, size: 16)
        actionLabel.textColor = UIColor.Common.darkGray
        actionLabel.text = "Create Fund"
        actionLabel.isUserInteractionEnabled = true
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(createNewFund))
        actionLabel.addGestureRecognizer(gest)
        
        let view = UIView()
        view.addSubview(actionLabel)
        
        actionLabel.anchor(top: view.topAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor,
                           padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
        bottomSheetController.addContentsView(view)
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.present()
    }
    
    private func createTradeAccount() {
        guard let vc = CreateAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func attachAccount() {
        guard let vc = AttachAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Attach external account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func addAccountSelector() {
        showActionSheet(with: nil,
                        message: nil,
                        firstActionTitle: "Create account",
                        firstHandler: { [weak self] in
                            self?.createTradeAccount()
            },
                        secondActionTitle: "Attach external account",
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

extension TradingViewController: DashBoardTradingTableViewCellButtonsActionsProtocol {
    func createFund() {
        createNewFund()
    }
    
    func createAccount() {
        addAccountSelector()
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
            vc.title = "Trading history"
            navigationController?.pushViewController(vc, animated: true)
        case .tradingPublicList:
            switch actionType {
            case .showAll:
                let vc = TradingPublicListViewController()
                vc.viewModel = TradingPublicListViewModel(viewModel.router, delegate: vc)
                vc.title = "Public"
                navigationController?.pushViewController(vc, animated: true)
            case .add:
                self.showCreateFundBottomSheet()
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
            if let viewModel = cellViewModel as? EventCollectionViewCellViewModel {
                self.showEvent(viewModel.event)
            }
        case .tradingPublicList:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel {
                showAsset(cellViewModel)
            }
        case .tradingPrivateList:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel, cellViewModel.type == ._none, let tradingAsset = cellViewModel.asset as? DashboardTradingAsset {
                showAccount(tradingAsset)
            }
        default:
            break
        }
    }
    
    func showAsset(_ asset: AssetCollectionViewCellViewModel) {
        let assetId = asset.getAssetId()
        let type = asset.type
        viewModel.router?.showAssetDetails(with: assetId, assetType: type)
    }
    func showAccount(_ tradingAsset: DashboardTradingAsset) {
        if let router = viewModel.router, let assetId = tradingAsset._id?.uuidString {
            let viewController = AccountViewController()
            let accountRouter = AccountRouter(parentRouter: router)
            accountRouter.accountViewController = viewController
            viewController.viewModel = AccountTabmanViewModel(withRouter: accountRouter, assetId: assetId)
            navigationController?.pushViewController(viewController, animated: true)
       }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleView.balanceLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadSections([indexPath.section], with: .fade)
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
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    enum SectionType {
        case overview
        case events
        case publicTrading
        case privateTrading
    }
    private var sections: [SectionType] = [.overview, .publicTrading, .privateTrading]
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = false
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingHeaderTableViewCellViewModel.self,
                CellWithCollectionViewModel<TradingEventsViewModel>.self,
                CellWithCollectionViewModel<TradingPublicShortListViewModel>.self,
                CellWithCollectionViewModel<TradingPrivateShortListViewModel>.self]
    }
    
    var details: DashboardTradingDetails? {
        didSet {
            let showCreateFund = publicTrading?.items?.count ?? 0 > 0 ? false : true
            let showCreateAccount = privateTrading?.items?.count ?? 0 > 0 ? false : true
            let overviewViewModel = TradingHeaderTableViewCellViewModel(data: TradingHeaderData(details: details, currency: currency, showCreateFund: showCreateFund, showCreateAccount: showCreateAccount), delegate: delegate, createsDelegate: creationDelegate)
            viewModels.append(overviewViewModel)
            reloadSection(.events)
            
            guard let count = details?.events?.items?.count, count > 0 else { return }
            
            sections.insert(.events, at: 1)
            let eventsViewModel = CellWithCollectionViewModel(TradingEventsViewModel(details, delegate: delegate), delegate: delegate)
            viewModels.append(eventsViewModel)
            delegate?.didReload()
        }
    }
    
    var publicTrading: DashboardTradingAssetItemsViewModel? {
        didSet {
            guard let count = publicTrading?.items?.count, count > 0 else { return }
            let viewModel = CellWithCollectionViewModel(TradingPublicShortListViewModel(publicTrading, delegate: delegate, router: router), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.publicTrading)
        }
    }
    
    var privateTrading: DashboardTradingAssetItemsViewModel? {
        didSet {
            guard let count = privateTrading?.items?.count, count > 0 else { return }
            let viewModel = CellWithCollectionViewModel(TradingPrivateShortListViewModel(privateTrading, delegate: delegate, router: router), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.privateTrading)
        }
    }
    
    lazy var currency = getPlatformCurrencyType()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    var router: DashboardRouter?
    weak var delegate: BaseTableViewProtocol?
    weak var creationDelegate: DashBoardTradingTableViewCellButtonsActionsProtocol?
    
    init(_ router: DashboardRouter?) {
        self.delegate = router?.tradingViewController
        self.creationDelegate = router?.tradingViewController
        self.router = router
    }
    
    private func reloadSection(_ section: SectionType) {
        let reloadSection = sections.firstIndex(of: section) ?? 0
        delegate?.didReload(IndexPath(row: 0, section: reloadSection))
    }
    
    func getTotalValue() -> String {
        if let total = details?.equity {
            return total.toString() + " " + currency.rawValue
        }
        
        return ""
    }
    
    func fetch() {
        viewModels.removeAll()
    
        DashboardDataProvider.getPrivateTrading(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.privateTrading = model
        }, errorCompletion: errorCompletion)
        
        DashboardDataProvider.getPublicTrading(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.publicTrading = model
            self?.fetchDetails()
        }, errorCompletion: errorCompletion)
        
        delegate?.didReload()
    }
    
    private func fetchDetails() {
        DashboardDataProvider.getTrading(currency, eventsTake: 12, completion: { [weak self] (model) in
            self?.details = model
        }, errorCompletion: errorCompletion)
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
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
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
}

