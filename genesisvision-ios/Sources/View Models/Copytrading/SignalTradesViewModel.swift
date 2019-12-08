//
//  SignalTradesViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class SignalTradesViewModel {
    // MARK: - Variables
    var title: String = "Trades"
    
    var router: SignalRouterProtocol!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var signalTradesProtocol: SignalTradesProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var count: String = ""
    
    var currency: CurrencyType?
    
    var skip = 0
    var take = ApiKeys.take
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var totalCount = 0 {
        didSet {
            count = "\(totalCount) trades"
        }
    }
    
    func noDataText() -> String {
        return self.isOpenTrades ? "There are no open trades" : "There are no trades"
    }
    
    var viewModels = [SignalTradesTableViewCellViewModel]() {
        didSet {
            self.sortModels(viewModels)
        }
    }
    
    var sections = [Date : [SignalTradesTableViewCellViewModel]]()
    var sortedSections = [Date]()
    
    var isOpenTrades: Bool = false
    var sortingDelegateManager: SortingDelegateManager!
    
    // MARK: - Init
    init(withRouter router: SignalRouterProtocol, reloadDataProtocol: ReloadDataProtocol?, isOpenTrades: Bool? = false, signalTradesProtocol: SignalTradesProtocol? = nil, currency: CurrencyType? = nil) {
        self.router = router
        self.currency = currency
        self.isOpenTrades = isOpenTrades ?? false
        
        self.reloadDataProtocol = reloadDataProtocol
        
        if self.isOpenTrades {
            self.router.signalOpenTradesViewController = reloadDataProtocol as? SignalOpenTradesViewController
        } else {
            self.router.signalTradesViewController = reloadDataProtocol as? SignalTradesViewController
        }
        
        self.signalTradesProtocol = signalTradesProtocol
        
        title = self.isOpenTrades ? "Open trades" : "Trades history"
        
        let sortingManager = SortingManager(self.isOpenTrades ? .signalTradesOpen : .signalTrades)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
    }
    
    func hideHeader(value: Bool = true) {

    }
    
    func close(_ tradeId: String) {
        SignalDataProvider.close(with: tradeId) { [weak self] (result) in
            self?.refresh(completion: { (result) in
                
            })
        }
    }
}

// MARK: - TableView
extension SignalTradesViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SignalTradesTableViewCellViewModel.self]
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
extension SignalTradesViewModel {
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
            var allViewModels = self?.viewModels ?? [SignalTradesTableViewCellViewModel]()
            
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
    func model(for indexPath: IndexPath) -> SignalTradesTableViewCellViewModel? {
        guard let section = sections[sortedSections[indexPath.section]] else { return nil }
        return section[indexPath.row]
    }
    
    // MARK: - Private methods
    private func sortModels(_ viewModels: [SignalTradesTableViewCellViewModel]) {
        var sections = [Date : [SignalTradesTableViewCellViewModel]]()
        
        for model in viewModels {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
            
            guard let dateStr = model.orderModel.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [model]
            } else {
                sections[date]!.append(model)
                sections[date] = sections[date]!.sorted(by: { $0.orderModel.date!.compare($1.orderModel.date!) == .orderedDescending })
            }
        }
        
        sortedSections = sections.keys.sorted(by: { $0.compare($1) == .orderedDescending })
        
        self.sections = sections
    }
    
    private func updateFetchedData(totalCount: Int, viewModels: [SignalTradesTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func saveTrades(_ tradesViewModel: TradesSignalViewModel?, _ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [SignalTradesTableViewCellViewModel]) -> Void, _ completionError: @escaping CompletionBlock) {
        
        guard tradesViewModel != nil else {
            return ErrorHandler.handleApiError(error: nil, completion: completionError)
        }
        
        var viewModels = [SignalTradesTableViewCellViewModel]()
        
        let totalCount = tradesViewModel?.total ?? 0
        
        tradesViewModel?.trades?.forEach({ (orderModel) in
            let viewModel = SignalTradesTableViewCellViewModel(orderModel: orderModel, isOpenTrades: self.isOpenTrades, delegate: self.signalTradesProtocol)
            viewModels.append(viewModel)
        })
        
        completionSuccess(totalCount, viewModels)
        completionError(.success)
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [SignalTradesTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
    
        if isOpenTrades {
            SignalDataProvider.getTradesOpen(with: nil, currency: currency, skip: skip, take: take, completion: { [weak self] (tradesViewModel) in
                self?.saveTrades(tradesViewModel, completionSuccess, completionError)
                }, errorCompletion: completionError)
        } else {
            let sorting = sortingDelegateManager.manager?.getSelectedSorting()
            
            SignalDataProvider.getTrades(from: dateFrom, dateTo: dateTo, sorting: sorting as? SignalAPI.Sorting_v10SignalTradesGet, currency: currency, skip: skip, take: take, completion: { [weak self ] (tradesViewModel) in
                self?.saveTrades(tradesViewModel, completionSuccess, completionError)
            }, errorCompletion: completionError)
        }
    }
}
