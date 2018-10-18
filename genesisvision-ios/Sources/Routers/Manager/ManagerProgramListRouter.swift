//
//  ManagerProgramListRouter.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

import UIKit.UINavigationController

enum ManagerProgramListRouteType {
    case showProgramDetails(programId: String)
}

class ManagerProgramListRouter: Router {
    var managerProgramsViewController: ManagerProgramListViewController!
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController? = nil, managerProgramsViewController: ManagerProgramListViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        self.managerProgramsViewController = managerProgramsViewController
    }
    
    // MARK: - Public methods
    func show(routeType: ManagerProgramListRouteType) {
        switch routeType {
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        }
    }
}

