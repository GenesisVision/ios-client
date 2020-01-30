//
//  ManagerRouter.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

class ManagerRouter: TabmanRouter {
    // MARK: - Variables
    var managerViewController: ManagerViewController?
    var managerInfoViewController: ManagerInfoViewController?
    
    // MARK: - Public methods
    func getInfo(with managerId: String) -> ManagerInfoViewController? {
        let vc = ManagerInfoViewController()
        
        let router = Router(parentRouter: self)
        router.currentController = vc
        let viewModel = ManagerInfoViewModel(withRouter: router, managerId: managerId, delegate: vc)
        vc.viewModel = viewModel
        vc.hidesBottomBarWhenPushed = true
        
        managerInfoViewController = vc
        return vc
    }
}

