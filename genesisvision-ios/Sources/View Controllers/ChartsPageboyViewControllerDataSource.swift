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
    var controllers = [BaseViewController]()

    init(router: DashboardRouter, dashboardPortfolioChartValue: DashboardChartValue?) {
        super.init()

        if let porfolioVC = PortfolioViewController.storyboardInstance(name: .dashboard) {
            porfolioVC.viewModel = PortfolioViewModel(withRouter: router, dashboardChartValue: dashboardPortfolioChartValue)
            porfolioVC.vc = router.chartsViewController

            controllers.append(porfolioVC)
        }
        
//        if let profitVC = ProfitViewController.storyboardInstance(name: .dashboard) {
//            profitVC.viewModel = ProfitViewModel(withRouter: router)
//            profitVC.vc = router.chartsViewController
//
//            controllers.append(profitVC)
//        }
    }
    
    func update(dashboardPortfolioChartValue: DashboardChartValue?, dashboardRequests: ProgramRequests?) {
        for controller in controllers {
            switch controller {
            case is PortfolioViewController:
                (controller as! PortfolioViewController).viewModel.dashboardChartValue = dashboardPortfolioChartValue
                (controller as! PortfolioViewController).viewModel.dashboardRequests = dashboardRequests
                (controller as! PortfolioViewController).updateUI()
            case is ProfitViewController:
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
