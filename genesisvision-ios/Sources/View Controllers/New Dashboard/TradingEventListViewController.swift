//
//  TradingEventListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingEventListViewController: ListViewController {
    typealias ViewModel = TradingEventListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
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
        isEnableInfiniteIndicator = true
        tableView.configure(with: .defaultConfiguration)
        
        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    private func showEvent(_ event: InvestmentEventViewModel) {
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

extension TradingEventListViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.didSelectEvent(at: assetId, assetType: assetType)
    }
}

extension TradingEventListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingEvents:
            if let viewModel = cellViewModel as? PortfolioEventTableViewCellViewModel {
                self.showEvent(viewModel.event)
            }
        default:
            break
        }
    }
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
}

class TradingEventListViewModel: ListViewModelWithPaging {
    var viewModels = [CellViewAnyModel]()
    var title = "Events"
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventTableViewCellViewModel.self]
    }
    var from: Date?
    var to: Date?
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    
    lazy var currency = selectedPlatformCurrency
    
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
        var models = [PortfolioEventTableViewCellViewModel]()
        EventsDataProvider.get(eventLocation: .dashboard, from: from, to: to, eventType: .all, assetType: .all, eventGroup: .tradingHistory, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.events?.forEach({ (event) in
                let viewModel = PortfolioEventTableViewCellViewModel(event: event)
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
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.tradingEvents, cellViewModel: model(at: indexPath))
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    
}
