//
//  AllEventsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class AllEventsViewModel {
    // MARK: - Variables
    var title: String = "Events"
    var assetId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var allowsSelection: Bool = true
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var eventsCount: String = ""
    var skip = 0
    var take = ApiKeys.take
    var totalCount = 0 {
        didSet {
            eventsCount = "\(totalCount) events"
        }
    }
    
    func noDataText() -> String {
        return "There are no events"
    }
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var viewModels = [PortfolioEventTableViewCellViewModel]() {
        didSet {
            self.sortModels(viewModels)
        }
    }
    
    var sections = [Date : [PortfolioEventTableViewCellViewModel]]()
    var sortedSections = [Date]()
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String? = nil, reloadDataProtocol: ReloadDataProtocol?, allowsSelection: Bool = true) {
        self.router = router
        self.assetId = assetId
        self.allowsSelection = allowsSelection
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    func hideHeader(value: Bool = true) {
        if let router = router as? ProgramRouter {
            router.programViewController.hideHeader(value)
        } else if let router = router as? FundRouter {
            router.fundViewController.hideHeader(value)
        }
    }
}

// MARK: - TableView
extension AllEventsViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventTableViewCellViewModel.self]
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
    
    func headerHeight(for section: Int) -> CGFloat {
        return sortedSections.count > 0 ? 20.0 : 0.0
    }
    
    func titleForHeader(in section: Int) -> String {
        return sortedSections[section].onlyDateFormatString
    }
    
    func didSelectPortfolioEvents(at indexPath: IndexPath) {
        guard !viewModels.isEmpty, let selectedModel = model(for: indexPath) else {
            return
        }
        
        let event = selectedModel.dashboardPortfolioEvent
        if let assetId = event.assetId?.uuidString, let type = event.assetType, let assetType = AssetType(rawValue: type.rawValue) {
            router.showAssetDetails(with: assetId, assetType: assetType)
        }
    }
}

// MARK: - Fetch
extension AllEventsViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
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
            var allViewModels = self?.viewModels ?? [PortfolioEventTableViewCellViewModel]()
            
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
    func model(for indexPath: IndexPath) -> PortfolioEventTableViewCellViewModel? {
        guard let section = sections[sortedSections[indexPath.section]] else { return nil }
        return section[indexPath.row]
    }
    
    // MARK: - Private methods
    private func sortModels(_ viewModels: [PortfolioEventTableViewCellViewModel]) {
        var sections = [Date : [PortfolioEventTableViewCellViewModel]]()
        
        for model in viewModels {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Bundle.main.locale
            
            guard let dateStr = model.dashboardPortfolioEvent.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [model]
            } else {
                sections[date]!.append(model)
                sections[date] = sections[date]!.sorted(by: { $0.dashboardPortfolioEvent.date!.compare($1.dashboardPortfolioEvent.date!) == .orderedDescending })
            }
        }
        
        sortedSections = sections.keys.sorted(by: { $0.compare($1) == .orderedDescending })
        
        self.sections = sections
    }
    
    private func updateFetchedData(totalCount: Int, viewModels: [PortfolioEventTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [PortfolioEventTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            DashboardDataProvider.getDashboardPortfolioEvents(with: assetId, from: dateFrom, to: dateTo, skip: skip, take: take, completion: { (portfolioEvents) in
                guard portfolioEvents != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [PortfolioEventTableViewCellViewModel]()
                
                let totalCount = portfolioEvents?.total ?? 0
                
                portfolioEvents?.events?.forEach({ (dashboardPortfolioEvent) in
                    let viewModel = PortfolioEventTableViewCellViewModel(dashboardPortfolioEvent: dashboardPortfolioEvent)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}



