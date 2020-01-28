//
//  AccountListViewController.swift
//  genesisvision-ios
//
//  Created by George on 09.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class AccountListViewController: ListViewController {
    typealias ViewModel = AccountTradeListViewModel
    
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
        isEnableInfiniteIndicator = true
        tableView.configure(with: .defaultConfiguration)

        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadData()
    }
}

extension AccountListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        
    }
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
}

class AccountTradeListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = TradesTableViewCellViewModel
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingTableViewCellViewModel.self]
    }

    var assetId: String?
    var isOpenTrades: Bool = false
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    var sortingDelegateManager: SortingDelegateManager!
    var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, assetId: String, isOpenTrades: Bool, currency: CurrencyType, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
        self.assetId = assetId
        self.isOpenTrades = isOpenTrades
        self.currency = currency
        
        let sortingManager = SortingManager(self.isOpenTrades ? .tradesOpen : .trades)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let sorting = sortingDelegateManager.manager?.getSelectedSorting()
        let currency = getPlatformCurrencyType()
        
        var models = [CellViewModel]()
        if isOpenTrades {
            AccountsDataProvider.getTradesOpen(with: assetId, sorting: sorting as? TradingaccountAPI.Sorting_getOpenTrades, symbol: nil, accountId: nil, currency: currency, skip: skip, take: take(), completion: { [weak self] (tradesViewModel) in
                guard let tradesViewModel = tradesViewModel, let total = tradesViewModel.total else { return }
                tradesViewModel.items?.forEach({ (model) in
                    let viewModel = CellViewModel(orderModel: model, currencyType: currency)
                    models.append(viewModel)
                })
                self?.updateViewModels(models, refresh: refresh, total: total)
            }, errorCompletion: errorCompletion)
        } else {
            AccountsDataProvider.getTrades(with: assetId, dateFrom: dateFrom, dateTo: dateTo, symbol: nil, sorting: sorting as? TradingaccountAPI.Sorting_getTrades, accountId: nil, currency: currency, skip: skip, take: take(), completion: { [weak self] (tradesViewModel) in
                guard let tradesViewModel = tradesViewModel, let total = tradesViewModel.total else { return }
                tradesViewModel.items?.forEach({ (model) in
                    let viewModel = CellViewModel(orderModel: model, currencyType: currency)
                    models.append(viewModel)
                })
                self?.updateViewModels(models, refresh: refresh, total: total)
            }, errorCompletion: errorCompletion)
        }
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        if models.count > 0 {
            skip += take()
        }
        viewModels = refresh ? models : viewModels + models
        delegate?.didReload()
    }
    
    func cellAnimations() -> Bool {
        return false
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.tradingPrivateList, cellViewModel: model(for: indexPath))
    }
}
