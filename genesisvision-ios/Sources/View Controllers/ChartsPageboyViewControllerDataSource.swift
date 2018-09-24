//
//  ChartsPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy

class ChartsPageboyViewControllerDataSource: NSObject, PageboyViewControllerDataSource {
    var controllers: [BaseViewController]!
    
    init(router: DashboardRouter) {
        super.init()
        
        if let porfolioVC = PortfolioViewController.storyboardInstance(name: .dashboard),
            let profitVC = ProfitViewController.storyboardInstance(name: .dashboard) {
            porfolioVC.viewModel = PortfolioViewModel(withRouter: router)
            porfolioVC.vc = router.chartsViewController
            
//            profitVC.viewModel = ProfitViewModel(withRouter: router)
            profitVC.vc = router.chartsViewController

            controllers = [porfolioVC, profitVC]
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
