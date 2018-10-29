//
//  ManagerTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerTabmanViewController: BaseTabmanViewController<ManagerTabmanViewModel> {
    
    // MARK: - Variables
    var scrollEnabled: Bool = true {
        didSet {
            //TODO:
        }
    }
    
    // MARK: - Public Methods
    func setup(_ managerProfileDetails: ManagerProfileDetails?) {
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

