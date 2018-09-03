//
//  ManagerDashboardTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 27/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerDashboardTabmanViewController: BaseTabmanViewController<ManagerDashboardTabmanViewModel> {
    // MARK: - Variables
    private var createProgramBarButtonItem: UIBarButtonItem?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setup()
        
        if !isInvestorApp {
            createProgramBarButtonItem = UIBarButtonItem(title: "Create Program", style: .done, target: self, action: #selector(createProgramButtonAction(_:)))
            navigationItem.rightBarButtonItem = createProgramBarButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Actions
    @IBAction func createProgramButtonAction(_ sender: UIButton) {
        viewModel.showCreateProgramVC()
    }
}
