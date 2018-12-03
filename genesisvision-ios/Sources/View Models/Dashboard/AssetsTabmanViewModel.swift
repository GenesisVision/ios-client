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
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        
        title = "Assets"
        items = [TabmanBar.Item(title: "Programs"),
                 TabmanBar.Item(title: "Funds")]
        
        font = UIFont.getFont(.semibold, size: 16)
        
        dataSource = AssetsPageboyViewControllerDataSource(router: router, filterModel: filterModel, showFacets: showFacets)
    }
}


final class RatingsTabmanViewModel: AssetsTabmanViewModel {
    // MARK: - Init
    override init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, tabmanViewModelDelegate: tabmanViewModelDelegate, searchBarEnable: searchBarEnable, showFacets: showFacets)
        
        title = "Ratings"
        items = [TabmanBar.Item(title: "2 -> 3"),
                 TabmanBar.Item(title: "3 -> 4"),
                 TabmanBar.Item(title: "4 -> 5"),
                 TabmanBar.Item(title: "5 -> 6"),
                 TabmanBar.Item(title: "6 -> 7")]
        
        font = UIFont.getFont(.semibold, size: 16)
    }
}
