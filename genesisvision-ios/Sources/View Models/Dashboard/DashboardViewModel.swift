//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class DashboardViewModel {
    
    enum SectionType {
        case header
        case programList
    }
    
    // MARK: - Variables
    var title: String = "Dashboard"
    
    private var sections: [SectionType] = [.header, .programList]
    
    private var router: DashboardRouter!
    private var dashboard: InvestorDashboard?
    
    var programsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }
    var sorting: InvestmentProgramsFilter.Sorting = .byOrdersAsc
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    var searchText = ""
    var viewModels = [DashboardTableViewCellViewModel]()
    
    var filter: InvestmentProgramsFilter?
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        
        filter = InvestmentProgramsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: .byOrdersAsc, name: searchText, levelMin: nil, levelMax: nil, profitAvgMin: nil, profitAvgMax: nil, profitTotalMin: nil, profitTotalMax: nil, profitTotalPercentMin: nil, profitTotalPercentMax: nil, profitAvgPercentMin: nil, profitAvgPercentMax: nil, profitTotalChange: nil, periodMin: nil, periodMax: nil, skip: skip, take: take)
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
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .programList:
            return modelsCount()
        case .header:
            return 1
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .programList:
            guard let sort = filter?.sorting else { return "Sort by " }
            
            return "Sort by " + getSortingValue(sortingKey: sort)
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
        let imageName = "img_dashboard_logo"
        return imageName
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse programs"
        return text.uppercased()
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: DashboardTableViewCellViewModel = model(at: indexPath) as? DashboardTableViewCellViewModel else { return }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return }
        
        router.show(routeType: .showProgramDetail(investmentProgramId: investmentProgramId.uuidString))
    }
    
    func invest(with investmentProgramId: String) {
        router.show(routeType: .invest(investmentProgramId: investmentProgramId))
    }
    
    func withdraw(with investmentProgramId: String, investedTokens: Double) {
        router.show(routeType: .withdraw(investmentProgramId: investmentProgramId, investedTokens: investedTokens))
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
    
    func fetchMore(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += take
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [DashboardTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
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
            return DashboardHeaderTableViewCellViewModel(investorDashboard: dashboard)
        case .programList:
            return viewModels[indexPath.row]
        }
    }
    
    func getDetailViewController(with indexPath: IndexPath) -> ProgramDetailViewController? {
        guard let model = model(at: indexPath) as? DashboardTableViewCellViewModel else {
                return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        return router.getDetailViewController(with: investmentProgramId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        DashboardDataProvider.getProgram(completion: { [weak self] (dashboard) in
            guard let dashboard = dashboard else { return completionError(.failure(reason: nil)) }
            
            self?.dashboard = dashboard
            
            var dashboardProgramViewModels = [DashboardTableViewCellViewModel]()
            
            let totalCount = dashboard.investmentPrograms?.count ?? 0
            
            dashboard.investmentPrograms?.forEach({ (dashboardProgram) in
                let dashboardTableViewCellModel = DashboardTableViewCellViewModel(investmentProgram: dashboardProgram)
                dashboardProgramViewModels.append(dashboardTableViewCellModel)
            })
            
            completionSuccess(totalCount, dashboardProgramViewModels)
            completionError(.success)
        })
    }
}
