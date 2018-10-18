//
//  ManagerRouter.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum ManagerRouteType {
}

class ManagerRouter: Router {
    var managerViewController: ManagerViewController!
    
    var managerHeaderViewController: ManagerHeaderViewController?
    var managerDetailsTabmanViewController: ManagerDetailsTabmanViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, managerViewController: ManagerViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.managerViewController = managerViewController
    }
    
    // MARK: - Public methods
    func show(routeType: ManagerRouteType) {
        
    }
}

