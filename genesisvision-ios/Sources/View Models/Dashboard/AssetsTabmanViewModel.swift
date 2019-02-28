//
//  AssetsTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

class AssetsTabmanViewModel: TabmanViewModel {
    var dataSource: AssetsPageboyViewControllerDataSource!
    
    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
    
        title = "Assets"
        font = UIFont.getFont(.semibold, size: 16)
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        
        if router is DashboardRouter {
            items = [TabmanBar.Item(title: "Programs"),
                     TabmanBar.Item(title: "Funds")]
//            items = [TabmanBar.Item(title: "Programs"),
//                     TabmanBar.Item(title: "Funds"),
//                     TabmanBar.Item(title: "Copytrading"),
//                     TabmanBar.Item(title: "Open trades"),
//                     TabmanBar.Item(title: "Trades history")]
        } else {
            items = [TabmanBar.Item(title: "Programs"),
                     TabmanBar.Item(title: "Funds")]
        }
        
        dataSource = AssetsPageboyViewControllerDataSource(router: router, filterModel: filterModel, showFacets: showFacets)
    }
}
