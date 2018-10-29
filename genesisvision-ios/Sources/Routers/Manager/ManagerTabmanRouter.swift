//
//  ManagerTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ManagerTabmanRouter: TabmanRouter {
    // MARK: - Variables
    var managerInfoViewController: ManagerInfoViewController?
    
    // MARK: - Public methods
    func getInfo(with managerProfileDetails: ManagerProfileDetails) -> ManagerInfoViewController? {
        guard let viewController = ManagerInfoViewController.storyboardInstance(name: .manager) else { return nil }
        
        let router = ManagerInfoRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ManagerInfoViewModel(withRouter: router, managerProfileDetails: managerProfileDetails, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        managerInfoViewController = viewController
        return viewController
    }
    
    func getPrograms(with managerId: String) -> ManagerProgramListViewController? {
        let viewController = ManagerProgramListViewController()
        let router = ManagerProgramListRouter(parentRouter: self, managerProgramsViewController: viewController)
        let viewModel = ManagerProgramListViewModel(withRouter: router, managerId: managerId)
        viewController.viewModel = viewModel

        return viewController
    }
    
    func getFunds(with managerId: String) -> ManagerFundListViewController? {
        let viewController = ManagerFundListViewController()
        let router = ManagerFundListRouter(parentRouter: self, managerFundsViewController: viewController)
        let viewModel = ManagerFundListViewModel(withRouter: router, managerId: managerId)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

