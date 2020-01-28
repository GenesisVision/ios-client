//
//  AccountTradesViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class AccountTradesViewModel: TradesViewModelProtocol {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var canPullToRefresh: Bool = true
    // MARK: - Variables
    typealias CellViewModel = TradesTableViewCellViewModel
    
    var title: String = "Trades"
    var assetId: String?
    
    var router: AccountRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var sortingDelegateManager: SortingDelegateManager!
    var currencyType: CurrencyType!
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var transactionsCount: String = ""
    var dateFrom: Date?
    var dateTo: Date?
    var skip = 0
    var take = ApiKeys.take

    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) trades"
        }
    }
    
    func noDataText() -> String {
        return self.isOpenTrades ? "There are no open positions" : "There are no trades"
    }
    
    var viewModels: [CellViewAnyModel]
    
    var sections = [Date : [CellViewAnyModel]]()
    var sortedSections = [Date]()
    
    var isOpenTrades: Bool = false
    
    // MARK: - Init
    init(withRouter router: AccountRouter, assetId: String, reloadDataProtocol: ReloadDataProtocol?, isOpenTrades: Bool? = false, currencyType: CurrencyType) {
        self.router = router
        self.assetId = assetId
        self.isOpenTrades = isOpenTrades ?? false
        self.reloadDataProtocol = reloadDataProtocol
        self.currencyType = currencyType
        title = self.isOpenTrades ? "Open positions" : "Trades"
        
        let sortingManager = SortingManager(self.isOpenTrades ? .tradesOpen : .trades)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
        
        viewModels = [CellViewAnyModel]()
    }
}

// MARK: - TableView
extension AccountTradesViewModel {
    // MARK: - Public methods
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [CellViewModel.self]
    }
    func numberOfRows(in section: Int) -> Int {
        guard let section = sections[sortedSections[section]] else { return 0 }
        return section.count
    }
}

// MARK: - Fetch
extension AccountTradesViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(at indexPath: IndexPath) -> Bool {
        if numberOfSections() == indexPath.section + 1
            && numberOfRows(in: indexPath.section) - ApiKeys.fetchThreshold == indexPath.row
            && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [CellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, viewModels: allViewModels)
            }, completionError: { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
        })
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            completion(.success)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewModel? {
        guard let section = sections[sortedSections[indexPath.section]] else { return nil }
        return section[indexPath.row] as? AccountTradesViewModel.CellViewModel
    }
    
    // MARK: - Private methods
    private func sortModels(_ viewModels: [CellViewAnyModel]) {
        var sections = [Date : [CellViewModel]]()
        
        for model in viewModels {
            guard let model = model as? CellViewModel else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
        
            if let orderModel = model.orderModel as? OrderModel, let dateStr = orderModel.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) {
                if sections.index(forKey: date) == nil {
                    sections[date] = [model]
                } else {
                    sections[date]!.append(model)
                    sections[date] = sections[date]!.sorted(by: { ($0.orderModel as? OrderModel)?.date!.compare((($1.orderModel as? OrderModel)?.date!)!) == .orderedDescending })
                }
            } else if let orderModel = model.orderModel as? OrderSignalModel, let dateStr = orderModel.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) {
                
                if sections.index(forKey: date) == nil {
                    sections[date] = [model]
                } else {
                    sections[date]!.append(model)
                    sections[date] = sections[date]!.sorted(by: { ($0.orderModel as? OrderSignalModel)?.date!.compare((($1.orderModel as? OrderSignalModel)?.date!)!) == .orderedDescending })
                }
            }
        }
        
        sortedSections = sections.keys.sorted(by: { $0.compare($1) == .orderedDescending })
        
        self.sections = sections
    }
    
    private func updateFetchedData(totalCount: Int, viewModels: [CellViewAnyModel]) {
        self.viewModels = viewModels
        self.sortModels(viewModels)
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return completionError(.failure(errorType: .apiError(message: nil))) }
        
        let sorting = sortingDelegateManager.manager?.getSelectedSorting()
        
        if isOpenTrades {
            AccountsDataProvider.getTradesOpen(with: assetId, sorting: sorting as? TradingaccountAPI.Sorting_getOpenTrades, skip: skip, take: take, completion: { [weak self] (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [CellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.items?.forEach({ (orderModel) in
                    let viewModel = CellViewModel(orderModel: orderModel, currencyType: self?.currencyType ?? .gvt)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
            }, errorCompletion: completionError)
        } else {
            AccountsDataProvider.getTrades(with: assetId, dateFrom: dateFrom, dateTo: dateTo, sorting: sorting as? TradingaccountAPI.Sorting_getTrades, skip: skip, take: take, completion: { [weak self] (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [CellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.items?.forEach({ (orderModel) in
                    let viewModel = CellViewModel(orderModel: orderModel, currencyType: self?.currencyType ?? .gvt)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
            }, errorCompletion: completionError)
        }
    }
}
