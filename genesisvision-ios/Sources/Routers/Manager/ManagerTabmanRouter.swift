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
        
        let router = Router(parentRouter: self)
        router.currentController = viewController
        let viewModel = ManagerInfoViewModel(withRouter: router, managerProfileDetails: managerProfileDetails, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        managerInfoViewController = viewController
        return viewController
    }
}

