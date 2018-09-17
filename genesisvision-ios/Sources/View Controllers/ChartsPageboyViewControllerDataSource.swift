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
    
    init(vc: UIViewController) {
        super.init()
        
        if let porfolio = PortfolioViewController.storyboardInstance(name: .dashboard),
            let profit = ProfitViewController.storyboardInstance(name: .dashboard) {
            porfolio.vc = vc
            profit.vc = vc

            controllers = [porfolio, profit]
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
