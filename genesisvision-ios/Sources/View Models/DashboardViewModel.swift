//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DashboardViewModel {
    
    // MARK: - Variables
    var title: String = "Dashboard"
    
    private var router: DashboardRouter!
    private var dashboard: InvestorDashboard?
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func invest() {
        router.show(routeType: .invest)
    }
    
    // MARK: - Data methods
    func loadDashboards(completion: @escaping CompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        InvestorAPI.apiInvestorDashboardGet(authorization: token) { [weak self] (dashboard, error) in
            guard error == nil else {
                return ErrorHandler.handleApiError(error: error, completion: completion)
            }
            
            self?.dashboard = dashboard
            completion(.success)
        }
    }
}

