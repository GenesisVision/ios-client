//
//  InvestingEventListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingEventListViewController: ListViewController {
    typealias ViewModel = InvestingEventListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
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
        tableView.configure(with: .defaultConfiguration)
        isEnableInfiniteIndicator = true
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
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
extension InvestingEventListViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.didSelectEvent(at: assetId, assetType: assetType)
    }
}

extension InvestingEventListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .investingEvents:
            if let viewModel = cellViewModel as? EventTableViewCellViewModel {
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

class InvestingEventListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var viewModels = [CellViewAnyModel]()
    
    var title = "History"
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [EventTableViewCellViewModel.self]
    }
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    var from: Date?
    var to: Date?
    
    lazy var currency = selectedPlatformCurrency
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var router: DashboardRouter?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: DashboardRouter?, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [EventTableViewCellViewModel]()
        EventsDataProvider.get(eventLocation: .dashboard, from: from, to: to, eventType: .all, assetType: .all, eventGroup: .investmentHistory, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.events?.forEach({ (event) in
                let viewModel = EventTableViewCellViewModel(event: event)
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
        delegate?.didSelect(.investingEvents, cellViewModel: model(for: indexPath))
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
}
