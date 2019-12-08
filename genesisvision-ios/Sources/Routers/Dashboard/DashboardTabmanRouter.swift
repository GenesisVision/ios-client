//
//  DashboardTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 05/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DashboardTabmanRouter: TabmanRouter {
    // MARK: - Variables
    var programInfoViewController: ProgramInfoViewController?
    
    // MARK: - Public methods
    func getDashboard() -> DashboardViewController? {
        let viewController = DashboardViewController()
        
        let navigationController = BaseNavigationController(rootViewController: viewController)
        let router = DashboardRouter(parentRouter: self, navigationController: navigationController, dashboardViewController: viewController)
        viewController.viewModel = DashboardViewModel(withRouter: router)
        
        return viewController
    }
}
