//
//  SignalTradingLogViewModel.swift
//  genesisvision-ios
//
//  Created by George on 17/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

final class SignalTradingLogViewModel {
    // MARK: - Variables
    var title: String = "Trading log"
    
    var router: SignalRouterProtocol!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var count: String = ""

    var currency: CurrencyType?
    
    var skip = 0
    var take = ApiKeys.take
    
    var totalCount = 0 {
        didSet {
            count = "\(totalCount) logs"
        }
    }
    
    func noDataText() -> String {
        return "There are no logs"
    }
    
    var viewModels = [SignalTradingLogTableViewCellViewModel]() {
        didSet {
            self.sortModels(viewModels)
        }
    }
    
    var sections = [Date : [SignalTradingLogTableViewCellViewModel]]()
    var sortedSections = [Date]()
    
    // MARK: - Init
    init(withRouter router: SignalRouterProtocol, reloadDataProtocol: ReloadDataProtocol?, currency: CurrencyType? = nil) {
        self.router = router
        self.currency = currency
        
        self.reloadDataProtocol = reloadDataProtocol
        
        self.router.signalTradingLogViewController = reloadDataProtocol as? SignalTradingLogViewController
    }
    
    func hideHeader(value: Bool = true) {
        
    }
}

// MARK: - TableView
extension SignalTradingLogViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SignalTradingLogTableViewCellViewModel.self]
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
extension SignalTradingLogViewModel {
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
            var allViewModels = self?.viewModels ?? [SignalTradingLogTableViewCellViewModel]()
            
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
    func model(for indexPath: IndexPath) -> SignalTradingLogTableViewCellViewModel? {
        guard let section = sections[sortedSections[indexPath.section]] else { return nil }
        return section[indexPath.row]
    }
    
    // MARK: - Private methods
    private func sortModels(_ viewModels: [SignalTradingLogTableViewCellViewModel]) {
        var sections = [Date : [SignalTradingLogTableViewCellViewModel]]()
        
        for model in viewModels {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
            
            guard let dateStr = model.event.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [model]
            } else {
                sections[date]!.append(model)
                sections[date] = sections[date]!.sorted(by: { $0.event.date!.compare($1.event.date!) == .orderedDescending })
            }
        }
        
        sortedSections = sections.keys.sorted(by: { $0.compare($1) == .orderedDescending })
        
        self.sections = sections
    }
    
    private func updateFetchedData(totalCount: Int, viewModels: [SignalTradingLogTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func saveEvents(_ eventsViewModel: ItemsViewModelSignalTradingEvent?, _ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [SignalTradingLogTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        guard eventsViewModel != nil else {
            return ErrorHandler.handleApiError(error: nil, completion: completionError)
        }
        var viewModels = [SignalTradingLogTableViewCellViewModel]()
        
        let totalCount = eventsViewModel?.total ?? 0
        
        eventsViewModel?.items?.forEach({ (eventModel) in
            let viewModel = SignalTradingLogTableViewCellViewModel(event: eventModel)
            viewModels.append(viewModel)
        })
        
        completionSuccess(totalCount, viewModels)
        completionError(.success)
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [SignalTradingLogTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        SignalDataProvider.getTradesLog(currency, skip: skip, take: take, completion: { [weak self] (eventsViewModel) in
            self?.saveEvents(eventsViewModel, completionSuccess, completionError: completionError)
        }, errorCompletion: completionError)
    }
}

