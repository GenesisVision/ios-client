//
//  ProgramRouter.swift
//  genesisvision-ios
//
//  Created by George on 28/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum ProgramRouteType {
    case notifications
}

class ProgramRouter: Router {
    var programViewController: ProgramViewController!
    
    var programHeaderViewController: ProgramHeaderViewController?
    var programDetailsTabmanViewController: ProgramDetailsTabmanViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, programViewController: ProgramViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.programViewController = programViewController
    }
    
    // MARK: - Public methods
    func show(routeType: ProgramRouteType) {
        switch routeType {
        case .notifications:
            let vc = BaseViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
