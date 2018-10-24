//
//  ChartsTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

class ChartsTabmanViewModel: TabmanViewModel {
    var dashboardPortfolioChartValue: DashboardChartValue?
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil, dashboardPortfolioChartValue: DashboardChartValue?) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        self.dashboardPortfolioChartValue = dashboardPortfolioChartValue
        style = .scrollingButtonBar
        font = UIFont.getFont(.semibold, size: 16)
    }
}
