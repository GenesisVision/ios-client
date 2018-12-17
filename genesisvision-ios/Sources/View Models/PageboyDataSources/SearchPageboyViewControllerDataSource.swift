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
    internal override func setup(router: Router, filterModel: FilterModel? = nil, showFacets: Bool) {
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
}
