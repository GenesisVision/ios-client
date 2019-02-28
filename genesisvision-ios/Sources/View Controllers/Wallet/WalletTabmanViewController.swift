//
//  WalletTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTabmanViewController: BaseTabmanViewController<WalletTabmanViewModel> {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    func setup() {
//        viewModel.setup(programDetailsFull)
    }
}

extension WalletTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}
