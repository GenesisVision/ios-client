//
//  AssetsPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy

class AssetsPageboyViewControllerDataSource: NSObject, PageboyViewControllerDataSource {
    var controllers = [BaseViewController]()
    
    init(router: Router) {
        super.init()
        
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
            
            controllers = [fundListViewController, programListViewController]
        } else {
            guard let programListViewController = ProgramListViewController.storyboardInstance(name: .programs) else { return }
            router.programsViewController = programListViewController
            
            let programListRouter = ProgramListRouter(parentRouter: router)
            let programsViewModel = ProgramListViewModel(withRouter: programListRouter, reloadDataProtocol: programListViewController)
            programListViewController.viewModel = programsViewModel
            
            guard let fundListViewController = FundListViewController.storyboardInstance(name: .funds) else { return }
            router.fundsViewController = fundListViewController
            
            let fundListRouter = FundListRouter(parentRouter: router)
            let fundsViewModel = FundListViewModel(withRouter: fundListRouter, reloadDataProtocol: fundListViewController)
            fundListViewController.viewModel = fundsViewModel
            
            controllers = [fundListViewController, programListViewController]
        }
    }
    
    func update(dashboardSummary: DashboardSummary?) {
        for controller in controllers {
            switch controller {
            case is DashboardProgramListViewController:
                //TODO:
                break
            default:
                break
            }
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return controllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return controllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
}