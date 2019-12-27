//
//  ManagerTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerTabmanViewController: BaseTabmanViewController<ManagerTabmanViewModel> {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    func setup(_ managerProfileDetails: PublicProfile?) {
        viewModel.setup(managerProfileDetails)
    }
}

extension ManagerTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}
