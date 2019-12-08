//
//  ProgramPeriodHistoryViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ProgramPeriodHistoryViewModel {
    // MARK: - Variables
    typealias CellViewModel = PeriodHistoryTableViewCellViewModel
    
    var title: String = "Period history"
    var programId: String?
    
    var router: ProgramRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var transactionsCount: String = ""
    var dateFrom: Date?
    var dateTo: Date?
    var skip = 0
    var take = ApiKeys.take
    var currency: CurrencyType?
    var allowsSelection = false
    
    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) periods"
        }
    }
    
    func noDataText() -> String {
        return "There are no items"
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
    init(withRouter router: ProgramRouter, programId: String, reloadDataProtocol: ReloadDataProtocol?, currency: CurrencyType? = nil) {
        self.router = router
        self.programId = programId
        self.reloadDataProtocol = reloadDataProtocol
        self.currency = currency
    }
    
    func hideHeader(value: Bool = true) {
        router.programViewController.hideHeader(value)
    }
}

// MARK: - TableView
extension ProgramPeriodHistoryViewModel {
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
extension ProgramPeriodHistoryViewModel {
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
        
        for viewModel in viewModels {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
            
            guard let dateStr = viewModel.model.dateFrom?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [viewModel]
            } else {
                sections[date]!.append(viewModel)
                sections[date] = sections[date]!.sorted(by: { $0.model.dateFrom!.compare($1.model.dateFrom!) == .orderedDescending })
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
        
        ProgramsDataProvider.getPeriodHistory(with: programId, dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take, completion: { [weak self] (periodsViewModel) in
            guard let periodsViewModel = periodsViewModel else {
                return ErrorHandler.handleApiError(error: nil, completion: completionError)
            }
            var viewModels = [CellViewModel]()
            
            let totalCount = periodsViewModel.total ?? 0
            
            periodsViewModel.periods?.forEach({ (model) in
                let viewModel = CellViewModel(model: model, currency: self?.currency)
                viewModels.append(viewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
        }, errorCompletion: completionError)
    }
}

