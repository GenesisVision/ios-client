//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class DashboardViewModel {
    
    // MARK: - Variables
    var title: String = "Dashboard"
    
    private var router: DashboardRouter!
    private var dashboard: InvestorDashboard?
    
    var programsCount: String = ""
    var skip = 0
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }
    var sorting: InvestmentProgramsFilter.Sorting = .byOrdersAsc
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    var searchText = ""
    var dashboardProgramViewModels = [DashboardTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
    }
}

// MARK: - TableView
extension DashboardViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return dashboardProgramViewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Navigation
extension DashboardViewModel {
    // MARK: - Public methods
    func showDetail(with investmentProgramID: String) {
        router.show(routeType: .showProgramDetail(investmentProgramID: investmentProgramID))
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
        
        skip += Constants.Api.take
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.dashboardProgramViewModels ?? [DashboardTableViewCellViewModel]()
            
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
    func model(for index: Int) -> DashboardTableViewCellViewModel? {
        return dashboardProgramViewModels[index]
    }
    
    func getDetailViewController(with index: Int) -> ProgramDetailViewController? {
        guard let model = model(for: index) else {
            return nil
        }
        
        return router.getDetailViewController(with: model.investmentProgram.id?.uuidString ?? "", state: .full)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) {
        self.dashboardProgramViewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        DashboardDataProvider.getProgram(completion: { (dashboard) in
            guard let dashboard = dashboard else { return completionError(.failure(reason: nil)) }
            
            var dashboardProgramViewModels = [DashboardTableViewCellViewModel]()
            
            let totalCount = dashboard.total ?? 0
            
            dashboard.investmentPrograms?.forEach({ (dashboardProgram) in
                let dashboardTableViewCellModel = DashboardTableViewCellViewModel(investmentProgram: dashboardProgram, delegate: nil)
                dashboardProgramViewModels.append(dashboardTableViewCellModel)
            })
            
            completionSuccess(totalCount, dashboardProgramViewModels)
            completionError(.success)
        })
    }
}
