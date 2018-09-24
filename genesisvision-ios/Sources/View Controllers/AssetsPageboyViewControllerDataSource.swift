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
    var controllers: [BaseViewController]!
    
    init(router: DashboardRouter) {
        super.init()
        
        if let programListViewController = DashboardProgramListViewController.storyboardInstance(name: .dashboard),
            let fundListController = DashboardProgramListViewController.storyboardInstance(name: .dashboard) {
            router.programListViewController = programListViewController
            router.fundListController = fundListController
            
            let programsViewModel = DashboardProgramListViewModel(withRouter: router)
            programListViewController.viewModel = programsViewModel
            
            let fundsViewModel = DashboardProgramListViewModel(withRouter: router)
            fundListController.viewModel = fundsViewModel
            
            controllers = [programListViewController, fundListController]
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
