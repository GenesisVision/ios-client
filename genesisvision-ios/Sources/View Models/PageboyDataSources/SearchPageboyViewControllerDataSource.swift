//
//  SearchPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SearchPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    // MARK: - Private methods
    internal override func setup(router: Router, showFacets: Bool, searchProtocol: SearchViewControllerProtocol?) {
        let filterModel = FilterModel()
        filterModel.mask = ""
        
        guard let followListViewController = router.getFollows(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        followListViewController.searchProtocol = searchProtocol
        router.followsViewController = followListViewController
        controllers.append(followListViewController)
        
        guard let fundListViewController = router.getFunds(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        fundListViewController.searchProtocol = searchProtocol
        router.fundsViewController = fundListViewController
        controllers.append(fundListViewController)
        
        guard let programListViewController = router.getPrograms(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        programListViewController.searchProtocol = searchProtocol
        router.programsViewController = programListViewController
        controllers.append(programListViewController)
        
        guard let managerListViewController = router.getManagers(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        managerListViewController.searchProtocol = searchProtocol
        router.managersViewController = managerListViewController
        controllers.append(managerListViewController)
    }
}
