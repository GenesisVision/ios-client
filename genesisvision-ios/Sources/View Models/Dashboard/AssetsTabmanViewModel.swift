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
    var dashboard: DashboardSummary? {
        didSet {
            //TODO: update item string
        }
    }
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate?, dashboard: DashboardSummary?) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        self.dashboard = dashboard
        style = .scrollingButtonBar
        font = UIFont.getFont(.semibold, size: 16)
    }
}
