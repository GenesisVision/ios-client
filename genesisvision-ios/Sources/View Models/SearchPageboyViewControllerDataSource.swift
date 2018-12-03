//
//  SearchPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy

class SearchPageboyViewControllerDataSource: NSObject, PageboyViewControllerDataSource {
    var controllers = [BaseViewController]()
    
    init(router: Router, filterModel: FilterModel? = nil, showFacets: Bool) {
        super.init()

        guard let programListViewController = router.getPrograms(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        router.programsViewController = programListViewController
        controllers.append(programListViewController)
        
        guard let fundListViewController = router.getFunds(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        router.fundsViewController = fundListViewController
        controllers.append(fundListViewController)
        
        guard let managerListViewController = router.getManagers(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        router.managersViewController = managerListViewController
        controllers.append(managerListViewController)
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
