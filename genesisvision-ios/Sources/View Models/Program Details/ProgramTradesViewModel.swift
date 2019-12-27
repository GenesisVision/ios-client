//
//  ProgramTradesViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ProgramTradesViewModel {
    // MARK: - Variables
    typealias CellViewModel = ProgramTradesTableViewCellViewModel
    
    var title: String = "Trades"
    var programId: String?
    
    var router: ProgramRouter!
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
    
    var viewModels = [CellViewModel]() {
        didSet {
            self.sortModels(viewModels)
        }
    }
    
    var sections = [Date : [CellViewModel]]()
    var sortedSections = [Date]()
    
    var isOpenTrades: Bool = false
    
    // MARK: - Init
    init(withRouter router: ProgramRouter, programId: String, reloadDataProtocol: ReloadDataProtocol?, isOpenTrades: Bool? = false, currencyType: CurrencyType) {
        self.router = router
        self.programId = programId
        self.isOpenTrades = isOpenTrades ?? false
        self.reloadDataProtocol = reloadDataProtocol
        self.currencyType = currencyType
        
        title = self.isOpenTrades ? "Open positions" : "Trades"
        
        let sortingManager = SortingManager(self.isOpenTrades ? .tradesOpen : .trades)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
    }

    func hideHeader(value: Bool = true) {
        router.programViewController.hideHeader(value)
    }
}

// MARK: - TableView
extension ProgramTradesViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [CellViewModel.self]
    }
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DateSectionTableHeaderView.self]
    }
    
    func numberOfSections() -> Int {
        return sortedSections.count
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = sections[sortedSections[section]] else { return 0 }
        return section.count
    }
    
    func isMetaTrader5() -> Bool {
        return true
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return sortedSections.count > 0 ? 30.0 : 0.0
    }
    
    func titleForHeader(in section: Int) -> String {
        return sortedSections[section].onlyDateFormatString
    }
}

// MARK: - Fetch
extension ProgramTradesViewModel {
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
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewModel? {
        guard let section = sections[sortedSections[indexPath.section]] else { return nil }
        return section[indexPath.row]
    }
    
    // MARK: - Private methods
    private func sortModels(_ viewModels: [CellViewModel]) {
        var sections = [Date : [CellViewModel]]()
        
        for model in viewModels {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
            
            guard let dateStr = model.orderModel?.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [model]
            } else {
                sections[date]!.append(model)
                sections[date] = sections[date]!.sorted(by: { $0.orderModel?.date!.compare(($1.orderModel?.date!)!) == .orderedDescending })
            }
        }
        
        sortedSections = sections.keys.sorted(by: { $0.compare($1) == .orderedDescending })
        
        self.sections = sections
    }
    
    private func updateFetchedData(totalCount: Int, viewModels: [CellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        guard let programId = programId else { return completionError(.failure(errorType: .apiError(message: nil))) }
        
        let sorting = sortingDelegateManager.manager?.getSelectedSorting()
        
        if isOpenTrades {
            ProgramsDataProvider.getTradesOpen(with: programId, sorting: sorting as? ProgramsAPI.Sorting_getProgramOpenTrades, skip: skip, take: take, completion: { [weak self] (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [CellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.items?.forEach({ (orderModel) in
                    let viewModel = CellViewModel(orderModel: orderModel, orderSignalModel: nil, currencyType: self?.currencyType ?? .gvt)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        } else {
            ProgramsDataProvider.getTrades(with: programId, dateFrom: dateFrom, dateTo: dateTo, sorting: sorting as? ProgramsAPI.Sorting_getAssetTrades, skip: skip, take: take, completion: { [weak self] (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [CellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.items?.forEach({ (orderModel) in
                    let viewModel = CellViewModel(orderModel: nil, orderSignalModel: orderModel, currencyType: self?.currencyType ?? .gvt)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        }
    }
}
