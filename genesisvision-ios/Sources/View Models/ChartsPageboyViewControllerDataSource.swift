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

    var portfolioVC: PortfolioViewController?
    
    init(router: DashboardRouter, dashboardPortfolioChartValue: DashboardChartValue?) {
        super.init()

        if let portfolioVC = PortfolioViewController.storyboardInstance(name: .dashboard) {
            portfolioVC.viewModel = PortfolioViewModel(withRouter: router, dashboardChartValue: dashboardPortfolioChartValue)
            portfolioVC.vc = router.chartsViewController
            
            controllers.append(portfolioVC)
            
            self.portfolioVC = portfolioVC
        }
    }
    
    func update(dashboardPortfolioChartValue: DashboardChartValue?, programRequests: ProgramRequests?) {
        portfolioVC?.viewModel.dashboardChartValue = dashboardPortfolioChartValue
        portfolioVC?.viewModel.programRequests = programRequests
        portfolioVC?.updateUI()
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
