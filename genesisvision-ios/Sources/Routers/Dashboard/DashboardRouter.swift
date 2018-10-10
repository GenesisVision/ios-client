//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum DashboardRouteType {
    case showProgramDetails(programId: String), programList, notificationList, allPortfolioEvents, requests(programRequests: ProgramRequests?)
}

class DashboardRouter: Router {
    
    var dashboardViewController: DashboardViewController!
    
    var chartsViewController: ChartsViewController?
    var eventsViewController: EventsViewController?
    var assetsViewController: AssetsViewController?
    
    var programListViewController: DashboardProgramListViewController?
    var fundListController: DashboardProgramListViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, dashboardViewController: DashboardViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.dashboardViewController = dashboardViewController
    }

    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        case .programList:
            showProgramList()
        case .notificationList:
            showNotificationList()
        case .allPortfolioEvents:
            showAllPortfolioEvents()
        case .requests(let programRequests):
            showRequests(programRequests)
        }
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .programList)
    }
    
    private func showAllPortfolioEvents() {
        //TODO:
        let vc = BaseViewController()
        //        let router = CreateProgramTabmanRouter(parentRouter: self, tabmanViewController: tabmanViewController)
        //        let viewModel = CreateProgramTabmanViewModel(withRouter: router, tabmanViewModelDelegate: tabmanViewController)
        //        vc.viewModel = viewModel
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showRequests(_ programRequests: ProgramRequests?) {
        dashboardViewController.showRequests(programRequests)
    }
}
