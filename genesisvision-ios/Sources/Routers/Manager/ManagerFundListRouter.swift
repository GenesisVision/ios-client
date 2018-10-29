//
//  ManagerFundListRouter.swift
//  genesisvision-ios
//
//  Created by George on 28/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum ManagerFundListRouteType {
    case showFundDetails(fundId: String)
}

class ManagerFundListRouter: Router {
    var managerFundsViewController: ManagerFundListViewController!
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController? = nil, managerFundsViewController: ManagerFundListViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        self.managerFundsViewController = managerFundsViewController
    }
    
    // MARK: - Public methods
    func show(routeType: ManagerFundListRouteType) {
        switch routeType {
        case .showFundDetails(let fundId):
            showFundDetails(with: fundId)
        }
    }
}


