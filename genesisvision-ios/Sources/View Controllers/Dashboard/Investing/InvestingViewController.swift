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
    
    func showRequests(_ requests: ItemsViewModelAssetInvestmentRequest?) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("In requests")
        viewModel.inRequestsDelegateManager.inRequestsDelegate = self
        viewModel.inRequestsDelegateManager.requestSelectable = false
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
        var assetId = ""
        let type = asset.type
        
        switch type {
        case .program:
            if let program = asset.asset.program, let id = program.id?.uuidString {
                assetId = id
            } else if let programInvesting = asset.asset.programInvesting, let id = programInvesting.id?.uuidString {
                assetId = id
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type, let id = tradingAsset.id?.uuidString {
                assetId = id
            }
        case .fund:
            if let fund = asset.asset.fund, let id = fund.id?.uuidString {
                assetId = id
            } else if let fundInvesting = asset.asset.fundInvesting, let id = fundInvesting.id?.uuidString {
                assetId = id
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type, let id = tradingAsset.id?.uuidString {
                assetId = id
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
}

extension InvestingViewController: InRequestsDelegateManagerProtocol {
    func didSelectRequest(at indexPath: IndexPath) {
        
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
            if let viewModel = cellViewModel as? PortfolioEventCollectionViewCellViewModel {
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
            vc.title = "Events"
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
            showRequests(viewModel.requests)
        default:
            break
        }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleView.balanceLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
    enum RowType {
        case overview
        case requests
        case events
        case funds
        case programs
    }
    private var rows: [RowType] = [.overview, .funds, .programs]
    
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
            reloadRow(.events)
            
            guard let count = details?.events?.items?.count, count > 0 else { return }
            rows.insert(.events, at: rows.contains(.requests) ? 2 : 1)
            
            let eventsViewModel = CellWithCollectionViewModel(InvestingEventsViewModel(details, delegate: delegate), delegate: delegate)
            viewModels.append(eventsViewModel)
            delegate?.didReload()
        }
    }
    var requests: ItemsViewModelAssetInvestmentRequest? {
        didSet {
            guard let count = requests?.items?.count, count > 0 else { return }
            rows.insert(.requests, at: 1)
            let viewModel = CellWithCollectionViewModel(InvestingRequestsViewModel(requests, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            delegate?.didReload()
        }
    }
    var fundInvesting: ItemsViewModelFundInvestingDetailsList? {
        didSet {
            guard let count = fundInvesting?.items?.count, count > 0 else { return }
            
            let viewModel = CellWithCollectionViewModel(InvestingFundsViewModel(fundInvesting, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.funds)
        }
    }
    var programInvesting: ItemsViewModelProgramInvestingDetailsList? {
        didSet {
            guard let count = programInvesting?.items?.count, count > 0 else { return }
            
            let viewModel = CellWithCollectionViewModel(InvestingProgramsViewModel(programInvesting, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.programs)
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
        viewModels = [CellViewAnyModel]()
        
        DashboardDataProvider.getInvesting(currency, eventsTake: 12, completion: { [weak self] (model) in
            self?.details = model
        }, errorCompletion: errorCompletion)
        fetchRequests()
        DashboardDataProvider.getInvestingFunds(currency: currency, skip: 0, take: 12, completion: { [weak self] (model) in
            self?.fundInvesting = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getInvestingPrograms(currency: currency, skip: 0, take: 12, completion: { [weak self] (model) in
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
        let type = rows[indexPath.row]
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
        let type = rows[indexPath.row]
        if type == .requests {
            delegate?.action(.investingRequests, actionType: .showAll)
        }
    }
    func modelsCount() -> Int {
        return rows.count
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
}
