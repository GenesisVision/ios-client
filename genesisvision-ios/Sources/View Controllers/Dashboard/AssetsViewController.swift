//
//  AssetsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class AssetsViewController: BaseTabmanViewController<AssetsTabmanViewModel> {
    // MARK: - Variables
    var pageboyDataSource: AssetsPageboyViewControllerDataSource!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Assets"
        
        pageboyDataSource = AssetsPageboyViewControllerDataSource(router: viewModel.router)
        
        self.dataSource = pageboyDataSource

            self.bar.items = [Item(title: "Programs"),
                              Item(title: "Funds")]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !(viewModel.router is DashboardRouter) {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
