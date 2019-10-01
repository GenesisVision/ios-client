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
    init(withRouter router: Router, dashboardPortfolioChartValue: DashboardChartValue?) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.dashboardPortfolioChartValue = dashboardPortfolioChartValue
        font = UIFont.getFont(.semibold, size: 16)
        items = [TMBarItem(title: "Portfolio")]
    }
}
