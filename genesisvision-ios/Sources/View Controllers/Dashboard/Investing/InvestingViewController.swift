//
//  InvestingViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingViewController: ListViewController {
    typealias ViewModel = InvestingViewModel
    
    // MARK: - Veriables
    var viewModel: ViewModel!
    let titleView = TitleView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        fetch()
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
        
        titleView.titleLabel.text = "Investing"
        titleView.balanceLabel.text = viewModel.getTotalValue()
        
        navigationItem.titleView = titleView
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
    
    func showRequests(_ requests: AssetInvestmentRequestItemsViewModel?) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("In requests")
        viewModel.inRequestsDelegateManager.inRequestsDelegate = self
        viewModel.inRequestsDelegateManager.requestSelectable = true
        viewModel.inRequestsDelegateManager.requests = requests
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.registerNibs(for: viewModel.inRequestsDelegateManager.inRequestsCellModelsForRegistration)
            tableView.delegate = self?.viewModel.inRequestsDelegateManager
            tableView.dataSource = self?.viewModel.inRequestsDelegateManager
            tableView.separatorStyle = .none
        }
        
        bottomSheetController.present()
    }
    
    func showAsset(_ asset: AssetCollectionViewCellViewModel) {
        let assetId = asset.getAssetId()
        let type = asset.type
        viewModel.router?.showAssetDetails(with: assetId, assetType: type)
    }
    
    func fetch() {
        viewModel.fetch()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension InvestingViewController: InRequestsDelegateManagerProtocol {
    func didSelectRequest(at indexPath: IndexPath) {
        guard let requests = viewModel.inRequestsDelegateManager.requests?.items, !requests.isEmpty else {
            return
        }

        let request = requests[indexPath.row]
        if let assetId = request.assetDetails?._id?.uuidString, let assetType = request.assetDetails?.assetType {
            viewModel.router?.showAssetDetails(with: assetId, assetType: assetType)
        }
    }
    
    func didCanceledRequest(completionResult: CompletionResult) {
        bottomSheetController.dismiss()
        
        switch completionResult {
        case .success:
            viewModel.fetchRequests()
        default:
            break
        }
    }
}

extension InvestingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleView.animate(scrollView.contentOffset.y)
    }
}

extension InvestingViewController: DelegateManagerProtocol {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
}

extension InvestingViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("show all \(type)")
        
        switch type {
        case .investingEvents:
            if let viewModel = cellViewModel as? EventCollectionViewCellViewModel {
                self.showEvent(viewModel.event)
            }
        case .investingRequests:
            let vc = BaseViewController()
            vc.title = "Requests"
            navigationController?.pushViewController(vc, animated: true)
        case .investingPrograms, .investingFunds:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel {
                showAsset(cellViewModel)
            }
        default:
            break
        }
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .investingEvents:
            let vc = InvestingEventListViewController()
            viewModel.router?.investingEventListViewController = vc
            vc.viewModel = InvestingEventListViewModel(viewModel.router, delegate: vc)
            vc.title = "Investment History"
            navigationController?.pushViewController(vc, animated: true)
        case .investingPrograms:
            let vc = InvestingProgramListViewController()
            vc.viewModel = InvestingProgramListViewModel(viewModel.router, delegate: vc)
            vc.title = "Programs"
            navigationController?.pushViewController(vc, animated: true)
        case .investingFunds:
            let vc = InvestingFundListViewController()
            vc.viewModel = InvestingFundListViewModel(viewModel.router, delegate: vc)
            vc.title = "Funds"
            navigationController?.pushViewController(vc, animated: true)
        case .investingRequests:
            showRequests(viewModel?.requests)
        default:
            break
        }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleView.balanceLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadSections([indexPath.section], with: .fade)
    }
}

extension InvestingViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.didSelectEvent(at: assetId, assetType: assetType)
    }
}

class InvestingViewModel: ViewModelWithListProtocol {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    enum SectionType {
        case overview
        case requests
        case events
        case funds
        case programs
    }
    private var sections: [SectionType] = [.overview, .funds, .programs]
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var inRequestsDelegateManager = InRequestsDelegateManager()
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [InvestingHeaderTableViewCellViewModel.self,
                CellWithCollectionViewModel<InvestingRequestsViewModel>.self,
                CellWithCollectionViewModel<InvestingEventsViewModel>.self,
                CellWithCollectionViewModel<InvestingProgramsViewModel>.self,
                CellWithCollectionViewModel<InvestingFundsViewModel>.self,
        ]
    }
    
    var details: DashboardInvestingDetails? {
        didSet {
            let overviewViewModel = InvestingHeaderTableViewCellViewModel(data: InvestingHeaderData(details: details, currency: currency), delegate: delegate)
            viewModels.append(overviewViewModel)
            reloadSection(.events)
            
            guard let count = details?.events?.items?.count, count > 0 else { return }
            sections.insert(.events, at: sections.contains(.requests) ? 2 : 1)
            
            let eventsViewModel = CellWithCollectionViewModel(InvestingEventsViewModel(details, delegate: delegate), delegate: delegate)
            viewModels.append(eventsViewModel)
            delegate?.didReload()
        }
    }
    var requests: AssetInvestmentRequestItemsViewModel? {
        didSet {
            guard let count = requests?.items?.count, count > 0 else { return }
            sections.insert(.requests, at: 1)
            let viewModel = CellWithCollectionViewModel(InvestingRequestsViewModel(requests, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            delegate?.didReload()
        }
    }
    var fundInvesting: FundInvestingDetailsListItemsViewModel? {
        didSet {
            guard let count = fundInvesting?.items?.count, count > 0 else { return }
            
            let viewModel = CellWithCollectionViewModel(InvestingFundsViewModel(fundInvesting, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.funds)
        }
    }
    var programInvesting: ProgramInvestingDetailsListItemsViewModel? {
        didSet {
            guard let count = programInvesting?.items?.count, count > 0 else { return }
            
            let viewModel = CellWithCollectionViewModel(InvestingProgramsViewModel(programInvesting, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.programs)
        }
    }
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    lazy var currency = getPlatformCurrencyType()
    
    var router: DashboardRouter?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: DashboardRouter?) {
        self.delegate = router?.investingViewController
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
        viewModels = [CellViewAnyModel]()
        
        DashboardDataProvider.getInvesting(currency, eventsTake: 12, completion: { [weak self] (model) in
            self?.details = model
        }, errorCompletion: errorCompletion)
        fetchRequests()
        DashboardDataProvider.getInvestingFunds(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.fundInvesting = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getInvestingPrograms(currency: currency, status: .active, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.programInvesting = model
        }, errorCompletion: errorCompletion)
        
        delegate?.didReload()
    }
    
    func fetchRequests() {
        RequestDataProvider.getAllRequests(skip: 0, take: 12, completion: { [weak self] (model) in
            self?.requests = model
        }, errorCompletion: errorCompletion)
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .overview:
            return viewModels.first{ $0 is InvestingHeaderTableViewCellViewModel }
        case .events:
            return viewModels.first{ $0 is CellWithCollectionViewModel<InvestingEventsViewModel> }
        case .requests:
            return viewModels.first{ $0 is CellWithCollectionViewModel<InvestingRequestsViewModel> }
        case .funds:
            return viewModels.first{ $0 is CellWithCollectionViewModel<InvestingFundsViewModel> }
        case .programs:
            return viewModels.first{ $0 is CellWithCollectionViewModel<InvestingProgramsViewModel> }
        }
    }
    func didSelect(at indexPath: IndexPath) {
        let type = sections[indexPath.section]
        if type == .requests {
            delegate?.action(.investingRequests, actionType: .showAll)
        }
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
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
}
