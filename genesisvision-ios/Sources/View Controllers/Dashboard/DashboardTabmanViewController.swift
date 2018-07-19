//
//  DashboardTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardTabmanViewController: BaseTabmanViewController<DashboardTabmanViewModel> {
    // MARK: - Variables
    private var createProgramBarButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.setup()
        
        if !isInvestorApp {
            createProgramBarButtonItem = UIBarButtonItem(title: "Create Program", style: .done, target: self, action: #selector(createProgramButtonAction(_:)))
            navigationItem.rightBarButtonItem = createProgramBarButtonItem
        }
    }
    
    // MARK: - Actions
    @IBAction func createProgramButtonAction(_ sender: UIButton) {
        viewModel.showCreateProgramVC()
    }
}
