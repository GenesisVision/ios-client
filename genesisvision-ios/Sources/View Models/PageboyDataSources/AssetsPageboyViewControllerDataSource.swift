//
//  AssetsPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AssetsPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    // MARK: - Private methods
    internal override func setup(router: Router, showFacets: Bool) {
        if let router = router as? DashboardRouter {
            
            if let programListViewController = getDashboardPrograms(router) {
                controllers.append(programListViewController)
            }
            
            if let fundListViewController = getDashboardFunds(router) {
                controllers.append(fundListViewController)
            }
            
            if signalEnable {
                if let signalListViewController = getSignalList(router) {
                    controllers.append(signalListViewController)
                }
                if let signalOpenTradesViewController = getOpenTrades(with: router) {
                    controllers.append(signalOpenTradesViewController)
                }
                
                if let signalTradesViewController = getTrades(with: router) {
                    controllers.append(signalTradesViewController)
                }
                if let signalTradingLogViewController = getTradesLog(with: router) {
                    controllers.append(signalTradingLogViewController)
                }
            }
        } else {
            guard let programListViewController = getPrograms(with: router, filterModel: FilterModel(), showFacets: showFacets), let fundListViewController = getFunds(with: router, filterModel: FilterModel(), showFacets: showFacets) else { return }
            
            controllers = [programListViewController, fundListViewController]
        }
    }
    
    func getDashboardPrograms(_ router: DashboardRouter) -> DashboardProgramListViewController? {
        guard let viewController = DashboardProgramListViewController.storyboardInstance(.dashboard) else { return nil}
        viewController.tableViewStyle = .plain
        router.programListViewController = viewController
        let programsViewModel = DashboardProgramListViewModel(withRouter: router)
        viewController.viewModel = programsViewModel
        
        return viewController
    }
    
    func getDashboardFunds(_ router: DashboardRouter) -> DashboardFundListViewController? {
        guard let viewController = DashboardFundListViewController.storyboardInstance(.dashboard) else { return nil}
        viewController.tableViewStyle = .plain
        router.fundListViewController = viewController
        let fundsViewModel = DashboardFundListViewModel(withRouter: router)
        viewController.viewModel = fundsViewModel
        
        return viewController
    }
    
    func getPrograms(with router: Router, filterModel: FilterModel? = nil, showFacets: Bool) -> ProgramListViewController? {
        guard let viewController = ProgramListViewController.storyboardInstance(.programs) else { return nil }
        router.programsViewController = viewController
        let programListRouter = ListRouter(parentRouter: router)
        programListRouter.currentController = viewController
        let programsViewModel =
            ListViewModel(withRouter: programListRouter, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .program)
        viewController.viewModel = programsViewModel
        
        return viewController
    }
    
    func getFunds(with router: Router, filterModel: FilterModel? = nil, showFacets: Bool) -> FundListViewController? {
        guard let viewController = FundListViewController.storyboardInstance(.funds) else { return nil }
        router.fundsViewController = viewController
        let fundListRouter = ListRouter(parentRouter: router)
        fundListRouter.currentController = viewController
        let fundsViewModel = ListViewModel(withRouter: fundListRouter, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .fund)
        viewController.viewModel = fundsViewModel
        
        return viewController
    }
    
    func getSignalList(_ router: DashboardRouter) -> SignalListViewController? {
        guard let viewController = SignalListViewController.storyboardInstance(.dashboard) else { return nil }
        viewController.tableViewStyle = .plain
        router.signalListViewController = viewController
        let dashboardSignalListViewModel = SignalListViewModel(withRouter: router)
        viewController.viewModel = dashboardSignalListViewModel
        
        return viewController
    }
    
    func getTrades(with router: DashboardRouter) -> SignalTradesViewController? {
        return router.getSignalTrades(with: router)
    }
    
    func getOpenTrades(with router: DashboardRouter) -> SignalOpenTradesViewController? {
        return router.getSignalOpenTrades(with: router)
    }
    
    func getTradesLog(with router: DashboardRouter) -> SignalTradingLogViewController? {
        return router.getSignalTradingLog(with: router)
    }
    
    
}
