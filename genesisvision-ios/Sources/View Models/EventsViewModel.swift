//
//  EventsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class EventListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var viewModels = [CellViewAnyModel]()
    var title = "History"
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [EventTableViewCellViewModel.self]
    }
    var from: Date?
    var to: Date?
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    
    var assetId: String?
    var assetType: AssetType = .program
    
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
        var models = [EventTableViewCellViewModel]()
        
        let assetType = AssetFilterType(rawValue: self.assetType.rawValue)
        
        EventsDataProvider.get(assetId, eventLocation: assetId == nil ? .eventsAll : .asset, from: from, to: to, eventType: .all, assetType: assetType, assetsIds: nil, forceFilterByIds: nil, eventGroup: .none, skip: skip, take: take(), completion: { [weak self] (model) in
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
        delegate?.didSelect(.tradingEvents, cellViewModel: model(for: indexPath))
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    
}

final class EventViewModelWithSections {
    // MARK: - Variables
    typealias CellViewModel = EventTableViewCellViewModel
    
    var title: String = "History"
    var assetId: String?
    
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var dateFrom: Date?
    var dateTo: Date?
    var skip = 0
    var take = ApiKeys.take
    var totalCount = 0
    var assetType: AssetType = .program
    
    var viewModels = [CellViewModel]() {
        didSet {
            sortModels(viewModels)
        }
    }
    
    var sections = [Date : [CellViewModel]]()
    var sortedSections = [Date]()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    init(reloadDataProtocol: ReloadDataProtocol?) {
        self.reloadDataProtocol = reloadDataProtocol
    }
}

extension EventViewModelWithSections {
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
    
    func headerHeight(for section: Int) -> CGFloat {
        return sortedSections.count > 0 ? 30.0 : 0.0
    }
    
    func titleForHeader(in section: Int) -> String {
        return sortedSections[section].onlyDateFormatString
    }
}

// MARK: - Fetch
extension EventViewModelWithSections {
    // MARK: - Public methods
    
    func fetchMore(at indexPath: IndexPath) -> Bool {
        
        if sections.count - 1 == indexPath.section && canFetchMoreResults {
            fetchMore()
        }
        
        return skip <= totalCount
    }
    
    func fetchMore() {
        guard skip <= totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [CellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: allViewModels.count, viewModels: allViewModels)
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
            
            guard let dateStr = viewModel.event.date?.onlyDateFormatString, let date = dateFormatter.date(from: dateStr) else { return }
            
            if sections.index(forKey: date) == nil {
                sections[date] = [viewModel]
            } else {
                sections[date]!.append(viewModel)
                sections[date] = sections[date]!.sorted(by: { $0.event.date!.compare($1.event.date!) == .orderedDescending })
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
        
        var models = [EventTableViewCellViewModel]()
        
        let assetType = AssetFilterType(rawValue: self.assetType.rawValue)
        
        EventsDataProvider.get(assetId, eventLocation: assetId == nil ? .eventsAll : .asset, from: dateFrom, to: dateTo, eventType: .all, assetType: assetType, assetsIds: nil, forceFilterByIds: nil, eventGroup: .none, skip: skip, take: take, completion: { (model) in
            guard let model = model else { return }
            let totalCount = model.events?.count ?? 0
            model.events?.forEach({ (event) in
                let viewModel = EventTableViewCellViewModel(event: event)
                models.append(viewModel)
            })
            
            completionSuccess(totalCount, models)
        }, errorCompletion: errorCompletion)
    }
}
