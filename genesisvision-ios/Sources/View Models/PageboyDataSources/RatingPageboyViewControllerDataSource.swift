//
//  RatingPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class RatingPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    // MARK: - Private methods
    internal override func setup(router: Router, filterModel: FilterModel? = nil, showFacets: Bool) {
        let filterModel = FilterModel()
        filterModel.dateRangeModel.dateFrom = nil
        filterModel.dateRangeModel.dateTo = nil
        
        
        guard let programListViewController = router.getPrograms(with: filterModel, showFacets: showFacets, parentRouter: router) else { return }
        
        controllers.append(programListViewController)
    }
}
