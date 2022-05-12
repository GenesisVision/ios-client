//
//  InvestingAssetListViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class InvestingAssetListViewController: BaseTabmanViewController<InvestingAssetTabmanViewModel> {
    // MARK: - Variables
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
    }
}

//extension InvestingAssetListViewController: WalletProtocol {
//    func didUpdateData() {
////        viewModel.reloadDetails()
//    }
//}
