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
            let programListViewController = DashboardProgramListViewController()
            let fundListViewController = DashboardFundListViewController()
            programListViewController.tableViewStyle = .plain
            fundListViewController.tableViewStyle = .plain
            
            router.programListViewController = programListViewController
            router.fundListViewController = fundListViewController
            
            let programsViewModel = DashboardProgramListViewModel(withRouter: router)
            programListViewController.viewModel = programsViewModel
            
            let fundsViewModel = DashboardFundListViewModel(withRouter: router)
            fundListViewController.viewModel = fundsViewModel
            
            controllers = [programListViewController, fundListViewController]
        } else {
            guard let programListViewController = ProgramListViewController.storyboardInstance(.programs) else { return }
            router.programsViewController = programListViewController
            
            let programListRouter = ListRouter(parentRouter: router)
            programListRouter.currentController = programListViewController
            let programsViewModel =
                ListViewModel(withRouter: programListRouter, reloadDataProtocol: programListViewController, filterModel: filterModel, showFacets: showFacets, assetType: .program)
            programListViewController.viewModel = programsViewModel
            
            guard let fundListViewController = FundListViewController.storyboardInstance(.funds) else { return }
            router.fundsViewController = fundListViewController
            
            let fundListRouter = ListRouter(parentRouter: router)
            fundListRouter.currentController = fundListViewController
            let fundsViewModel = ListViewModel(withRouter: fundListRouter, reloadDataProtocol: fundListViewController, filterModel: filterModel, showFacets: showFacets, assetType: .fund)
            fundListViewController.viewModel = fundsViewModel
            
            controllers = [programListViewController, fundListViewController]
        }
    }
}
