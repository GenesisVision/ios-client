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

        if let router = viewModel.router as? DashboardRouter {
            pageboyDataSource = AssetsPageboyViewControllerDataSource(router: router)
        }
        
        self.dataSource = pageboyDataSource
        
        // configure the bar
        self.bar.items = [Item(title: "Programs"),
                          Item(title: "Funds")]
    }

    // MARK: - Public methods
    // MARK: - Private methods

}

extension AssetsViewController: ProgramDetailViewControllerProtocol {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool) {
        showProgressHUD()
        if let programListViewController = pageboyDataSource.controllers.first as? ProgramListViewController,
            let viewModel = programListViewController.viewModel {
            viewModel.changeFavorite(value: value, investmentProgramId: programID, request: request) { [weak self] (result) in
                self?.hideHUD()
            }
        }
    }
}

