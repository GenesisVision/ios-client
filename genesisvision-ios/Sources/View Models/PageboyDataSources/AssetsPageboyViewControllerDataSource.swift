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
    internal override func setup(router: Router, filterModel: FilterModel? = nil, showFacets: Bool) {
        if let router = router as? DashboardRouter {
            
            let programListViewController = getDashboardPrograms(router)
            let fundListViewController = getDashboardFunds(router)
            
            controllers = [programListViewController, fundListViewController]
            
            if signalEnable {
                controllers = [programListViewController, fundListViewController]
                
                let signalListViewController = getSignalList(router)
                let signalTradesViewController = getTrades(with: router)
                let signalOpenTradesViewController = getOpenTrades(with: router)
                
                controllers.append(contentsOf: [signalListViewController, signalOpenTradesViewController, signalTradesViewController])
            }
        } else {
            guard let programListViewController = getPrograms(with: router, filterModel: filterModel, showFacets: showFacets), let fundListViewController = getFunds(with: router, filterModel: filterModel, showFacets: showFacets) else { return }
            
            controllers = [programListViewController, fundListViewController]
        }
    }
    
    func getDashboardPrograms(_ router: DashboardRouter) -> DashboardProgramListViewController {
        let viewController = DashboardProgramListViewController()
        viewController.tableViewStyle = .plain
        router.programListViewController = viewController
        let programsViewModel = DashboardProgramListViewModel(withRouter: router)
        viewController.viewModel = programsViewModel
        
        return viewController
    }
    
    func getDashboardFunds(_ router: DashboardRouter) -> DashboardFundListViewController {
        let viewController = DashboardFundListViewController()
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
    
    func getSignalList(_ router: DashboardRouter) -> SignalListViewController {
        let viewController = SignalListViewController()
        viewController.tableViewStyle = .plain
        router.signalListViewController = viewController
        let dashboardSignalListViewModel = SignalListViewModel(withRouter: router)
        viewController.viewModel = dashboardSignalListViewModel
        
        return viewController
    }
    
    func getTrades(with router: DashboardRouter) -> SignalTradesViewController {
        let viewController = SignalTradesViewController()
        viewController.tableViewStyle = .plain
        router.signalTradesViewController = viewController
        let viewModel = SignalTradesViewModel(withRouter: router, reloadDataProtocol: viewController, isOpenTrades: false)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getOpenTrades(with router: DashboardRouter) -> SignalOpenTradesViewController {
        let viewController = SignalOpenTradesViewController()
        viewController.tableViewStyle = .plain
        router.signalOpenTradesViewController = viewController
        let viewModel = SignalTradesViewModel(withRouter: router, reloadDataProtocol: viewController, isOpenTrades: true, signalTradesProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
