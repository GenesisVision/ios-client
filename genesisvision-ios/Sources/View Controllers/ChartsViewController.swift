//
//  ChartsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ChartsTabmanViewModel: TabmanViewModel {
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate?) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        style = .scrollingButtonBar
    }
}

class ChartsViewController: BaseTabmanViewController<ChartsTabmanViewModel> {
    // MARK: - Variables
    var pageboyDataSource: ChartsPageboyViewControllerDataSource!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        pageboyDataSource = ChartsPageboyViewControllerDataSource(vc: self)
        
        self.dataSource = pageboyDataSource
        
        // configure the bar
        self.bar.items = [Item(title: "Portfolio"),
                          Item(title: "Profit")]
    }

    // MARK: - Public methods
    func updateViewConstraints(_ yOffset: CGFloat) {
        if let controllers = pageboyDataSource.controllers {
            for controller in controllers {
                if let vc = controller as? PortfolioViewController {
                    vc.updateViewConstraints(yOffset)
                }
                if let vc = controller as? ProfitViewController {
                    vc.updateViewConstraints(yOffset)
                }
            }
        }
    }

    // MARK: - Private methods
    
}

