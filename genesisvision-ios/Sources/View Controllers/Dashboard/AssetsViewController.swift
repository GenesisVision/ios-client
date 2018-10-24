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

        pageboyDataSource = AssetsPageboyViewControllerDataSource(router: viewModel.router)
        
        self.dataSource = pageboyDataSource

            self.bar.items = [Item(title: "Programs"),
                              Item(title: "Funds")]
    }
}
