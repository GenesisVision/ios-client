//
//  ReferralProgramViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ReferralProgramViewController: BaseTabmanViewController<ReferralProgramViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    private func setup() {
        navigationItem.title = viewModel.title
        dataSource = viewModel.dataSource
    }
}
