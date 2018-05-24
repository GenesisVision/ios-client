//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class DashboardTabmanViewModel: TabmanViewModel {
    // MARK: - Init
    override init(withRouter router: Router, viewControllersCount: Int, defaultPage: Int, tabmanViewModelDelegate: TabmanViewModelDelegate?) {
        super.init(withRouter: router, viewControllersCount: viewControllersCount, defaultPage: defaultPage, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Dashboard"
        isScrollEnabled = false
    }
}

final class DashboardViewModel {
    
    enum SectionType {
        case header
        case programList
    }
    
    // MARK: - Variables
    var activePrograms = true
    
    var title = "Dashboard"
    
    private var sections: [SectionType] = [.header, .programList]
    
    private var router: DashboardRouter!
    private var dashboard: InvestorDashboard?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var programsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }
    var sorting: InvestorAPI.Sorting_apiInvestorDashboardGet = Constants.Sorting.dashboardDefault
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    var searchText = ""
    var viewModels = [DashboardTableViewCellViewModel]() {
        didSet {
            self.activeViewModels = viewModels.filter { $0.investmentProgram.isArchived != true }
            self.archiveViewModels = viewModels.filter { $0.investmentProgram.isArchived == true }
        }
    }
    var activeViewModels = [DashboardTableViewCellViewModel]()
    var archiveViewModels = [DashboardTableViewCellViewModel]()
    
    var sortingKeys: [InvestorAPI.Sorting_apiInvestorDashboardGet] = [.byProfitDesc, .byProfitAsc,
                                                                      .byLevelDesc, .byLevelAsc,
                                                                      .byBalanceDesc, .byBalanceAsk,
                                                                      .byOrdersDesc, .byOrdersAsc,
                                                                      .byEndOfPeriodDesc, .byEndOfPeriodAsc,
                                                                      .byTitleDesc, .byTitleAsc]
    
    var sortingValues: [String] = ["profit ⇣", "profit ⇡",
                                   "level ⇣", "level ⇡",
                                   "balance ⇣", "balance ⇡",
                                   "orders ⇣", "orders ⇡",
                                   "end of period ⇣", "end of period ⇡",
                                   "title ⇣", "title ⇡"]
    
    struct SortingList {
        var sortingValue: String
        var sortingKey: InvestorAPI.Sorting_apiInvestorDashboardGet
    }
    
    var sortingList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingKeys[index])
        }
    }
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.topViewController() as? ReloadDataProtocol
    }
    
    // MARK: - Public methods
    func getSortingValue(sortingKey: InvestorAPI.Sorting_apiInvestorDashboardGet) -> String {
        guard let index = sortingKeys.index(of: sortingKey) else { return "" }
        return sortingValues[index]
    }
    
    func changeSorting(at index: Int) {
        sorting = sortingKeys[index]
    }
    
    func getSelectedSortingIndex() -> Int {
        return sortingKeys.index(of: sorting) ?? 0
    }
    
    func changeFavorite(value: Bool, at investmentProgramId: String, completion: @escaping CompletionBlock) {
        
    }
    
    func changeFavorite(value: Bool, investmentProgramId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: investmentProgramId) as? DashboardTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.investmentProgram.isFavorite = value
            completion(.success)
            return
        }
        
        ProgramDataProvider.programFavorites(isFavorite: !value, investmentProgramId: investmentProgramId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: investmentProgramId) as? DashboardTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.investmentProgram.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
}

// MARK: - TableView
extension DashboardViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardHeaderTableViewCellViewModel.self, DashboardTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SortHeaderView.self]
    }
    
    func modelsCount() -> Int {
        return activePrograms ? activeViewModels.count : archiveViewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .programList:
            return modelsCount()
        case .header:
            return 1
        }
    }
    
    func sortTitle() -> String? {
        return "Sort by " + getSortingValue(sortingKey: sorting)
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .programList:
            return nil
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .programList:
            return 50.0
        case .header:
            return 0.0
        }
    }
}

// MARK: - Navigation
extension DashboardViewModel {
    func logoImageName() -> String? {
        let imageName = "img_dashboard_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "you don’t have \nany programs yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse programs"
        return text.uppercased()
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: DashboardTableViewCellViewModel = model(at: indexPath) as? DashboardTableViewCellViewModel else { return }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return }
        
        router.show(routeType: .showProgramDetails(investmentProgramId: investmentProgramId.uuidString))
    }
    
    func showProgramList() {
        router.show(routeType: .programList)
    }
}

// MARK: - Fetch
extension DashboardViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [DashboardTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
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
        guard let dashboard = dashboard else {
            return nil
        }
        
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return modelsCount() > 0 ? DashboardHeaderTableViewCellViewModel(investorDashboard: dashboard) : nil
        case .programList:
            return activePrograms ? activeViewModels[indexPath.row] : archiveViewModels[indexPath.row]
        }
    }
    
    func model(at investmentProgramId: String) -> CellViewAnyModel? {
        if activePrograms {
            if let i = activeViewModels.index(where: { $0.investmentProgram.id?.uuidString == investmentProgramId }) {
                return activeViewModels[i]
            }
        } else {
            if let i = archiveViewModels.index(where: { $0.investmentProgram.id?.uuidString == investmentProgramId }) {
                return archiveViewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramDetailsTabmanViewController? {
        guard let model = model(at: indexPath) as? DashboardTableViewCellViewModel else {
            return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        return router.getDetailsViewController(with: investmentProgramId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        DashboardDataProvider.getProgram(with: sorting, completion: { [weak self] (dashboard) in
            guard let dashboard = dashboard else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            self?.dashboard = dashboard
            
            var dashboardProgramViewModels = [DashboardTableViewCellViewModel]()
            
            let totalCount = dashboard.investmentPrograms?.count ?? 0
            
            dashboard.investmentPrograms?.forEach({ (dashboardProgram) in
                let dashboardTableViewCellModel = DashboardTableViewCellViewModel(investmentProgram: dashboardProgram, reloadDataProtocol: self, delegate: self?.router.dashboardViewController)
                dashboardProgramViewModels.append(dashboardTableViewCellModel)
            })
            
            completionSuccess(totalCount, dashboardProgramViewModels)
            completionError(.success)
        }, errorCompletion: completionError)
    }
}

extension DashboardViewModel: ReloadDataProtocol {
    func didReloadData() {
        refresh { (result) in }
    }
}
