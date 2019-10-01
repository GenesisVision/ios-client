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
    init(withRouter router: Router, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
    
        title = "Assets"
        font = UIFont.getFont(.semibold, size: 16)
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        
        items = [TMBarItem(title: "Programs"),
                 TMBarItem(title: "Funds")]
        
        if signalEnable, router is DashboardRouter {
            items?.append(contentsOf: [TMBarItem(title: "Copytrading"),
                                       TMBarItem(title: "Open trades"),
                                       TMBarItem(title: "Trades history"),
                                       TMBarItem(title: "Trading log")])
        }
        
        dataSource = AssetsPageboyViewControllerDataSource(router: router, showFacets: showFacets)
    }
}
