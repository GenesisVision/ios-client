//
//  ChartsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ChartsViewController: BaseTabmanViewController<ChartsTabmanViewModel> {
    // MARK: - Variables
    var pageboyDataSource: ChartsPageboyViewControllerDataSource!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bounces = false
        if let router = viewModel.router as? DashboardRouter {
            pageboyDataSource = ChartsPageboyViewControllerDataSource(router: router, dashboardPortfolioChartValue: viewModel.dashboardPortfolioChartValue)
        }
        
        self.dataSource = pageboyDataSource
        
        // configure the bar
        self.bar.items = [Item(title: "Portfolio")]
    }

    // MARK: - Public methods
    func updateViewConstraints(_ yOffset: CGFloat) {
        for controller in pageboyDataSource.controllers {
            if let vc = controller as? PortfolioViewController {
                vc.updateViewConstraints(yOffset)
            }
            if let vc = controller as? ProfitViewController {
                vc.updateViewConstraints(yOffset)
            }
        }
    }
    
    func hideChart(_ value: Bool) {
        pageboyDataSource.portfolioVC?.hideChart(value)
    }

    // MARK: - Private methods
    
}

