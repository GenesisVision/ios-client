//
//  DashboardSignalListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class SignalListViewModel: ListViewModelProtocol {
    // MARK: - Variables
    var title = "Signals"
    
    var assetType: AssetType = .signal
    
    var signalListDelegateManager: ListDelegateManager<SignalListViewModel>!
    
    var activePrograms = true
    
    var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    
    var filterModel: FilterModel = FilterModel()
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    var canPullToRefresh = false
    var canFetchMoreResults = true
    var skip = 0
    var take = ApiKeys.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Signals \(totalCount)" : "Signals"
        }
    }
    
    var bottomViewType: BottomViewType = .filter
    
    var viewModels = [CellViewAnyModel]() {
        didSet {
            guard let viewModels = viewModels as? [SignalTableViewCellViewModel] else { return }
            
            self.allViewModels = viewModels
        }
    }
    var allViewModels = [SignalTableViewCellViewModel]()
    
    var facetsViewModels: [CellViewAnyModel]?
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.signalListViewController
        
        signalListDelegateManager = ListDelegateManager(with: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? SignalTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.signal.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? SignalTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.signal.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["programId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
    
    private func reinvest(_ value: Bool, programId: String) {
        if value {
            ProgramsDataProvider.reinvestOn(with: programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        } else {
            ProgramsDataProvider.reinvestOff(with: programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        }
    }
}

// MARK: - TableView
extension SignalListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SignalTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return allViewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
}

// MARK: - Navigation
extension SignalListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don't have any signal programs yet"
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse assets"
        return text
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: SignalTableViewCellViewModel = model(at: indexPath) as? SignalTableViewCellViewModel else { return }
        
        let program = model.signal
        guard let programId = program.id else { return }
        
        router.show(routeType: .showAssetDetails(assetId: programId.uuidString, assetType: .program))
    }
    
    func showProgramList() {
        if let router = router as? DashboardRouter {
            router.show(routeType: .assetList)
        }
    }
    
    func showFilterVC() {
        router.show(routeType: .showFilterVC(listViewModel: self, filterModel: self.filterModel, filterType: .dashboardPrograms, sortingType: .dashboardPrograms))
    }
}

// MARK: - Fetch
extension SignalListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMore(at indexPath: IndexPath) -> Bool {
        if modelsCount() - ApiKeys.fetchThreshold == indexPath.row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [SignalTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels as! [SignalTableViewCellViewModel])
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
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        return allViewModels[indexPath.row]
    }
    
    func model(at assetId: String) -> CellViewAnyModel? {
        if let i = allViewModels.firstIndex(where: { $0.signal.id?.uuidString == assetId }) {
            return allViewModels[i]
        }
        
        return nil
    }
    
    func getProgramViewController(with indexPath: IndexPath) -> ProgramViewController? {
        guard let model = model(at: indexPath) as? SignalTableViewCellViewModel else {
            return nil
        }
        
        let program = model.signal
        guard let programId = program.id, let router = router as? DashboardRouter else { return nil}
        
        return router.getProgramViewController(with: programId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [SignalTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [SignalTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        let dateFrom = filterModel.dateRangeModel.dateFrom
        let dateTo = filterModel.dateRangeModel.dateTo
        
        let sorting = filterModel.sortingModel.selectedSorting
        
        let chartPointsCount = filterModel.chartPointsCount
        
        var currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorSignalsGet?
        if let newCurrency = InvestorAPI.CurrencySecondary_v10InvestorSignalsGet(rawValue: getSelectedCurrency()) {
            currencySecondary = newCurrency
        }
        
        let actionStatus: InvestorAPI.ActionStatus_v10InvestorSignalsGet? = .none
        let dashboardActionStatus: InvestorAPI.DashboardActionStatus_v10InvestorSignalsGet? = filterModel.onlyActive ? .active : .all
        
        DashboardDataProvider.getSignalList(with: sorting as? InvestorAPI.Sorting_v10InvestorSignalsGet, from: dateFrom, to: dateTo, chartPointsCount: chartPointsCount, currencySecondary: currencySecondary, actionStatus: actionStatus, dashboardActionStatus: dashboardActionStatus, skip: skip, take: take, completion: { [weak self] (signalList) in
            guard let signalList = signalList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            var viewModels = [SignalTableViewCellViewModel]()
            
            let totalCount = signalList.programs?.count ?? 0
            
            signalList.programs?.forEach({ (signal) in
                if let router = self?.router as? DashboardRouter {
                    let dashboardTableViewCellModel = SignalTableViewCellViewModel(signal: signal, reloadDataProtocol: router.signalListViewController, delegate:
                        router.signalListViewController)
                    viewModels.append(dashboardTableViewCellModel)
                }
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
        }, errorCompletion: completionError)
    }
}


