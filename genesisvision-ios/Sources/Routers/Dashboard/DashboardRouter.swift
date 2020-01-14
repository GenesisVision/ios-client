//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum DashboardRouteType {
    
}

class DashboardRouter: Router, ListRouterProtocol {
//    var signalOpenTradesViewController: SignalOpenTradesViewController?
//    
//    var signalTradesViewController: SignalTradesViewController?
//    
//    var signalTradingLogViewController: SignalTradingLogViewController?
//    

    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, dashboardViewController: DashboardViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.dashboardViewController = dashboardViewController
    }
    
    // MARK: - Private methods
    private func showRequests(_ programRequests: AssetRequestDetails?) {
//        dashboardViewController.showRequests(programRequests)
    }
    
    private func showEventDetails(_ event: InvestmentEventViewModel) {
//        dashboardViewController.showDetails(event)
    }
}

