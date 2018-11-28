//
//  AssetsTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class AssetsTabmanViewModel: TabmanViewModel {

    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Assets"
        items = [TabmanBar.Item(title: "Programs"),
                 TabmanBar.Item(title: "Funds")]
        
        font = UIFont.getFont(.semibold, size: 16)
    }
    
    func refresh() {
        
    }
}
