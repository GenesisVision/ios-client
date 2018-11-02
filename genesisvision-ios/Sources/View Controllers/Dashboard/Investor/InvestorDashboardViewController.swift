//
//  InvestorDashboardViewController.swift
//  genesisvision-ios
//
//  Created by George on 27/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class InvestorDashboardViewController: DashboardViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomViewType = .dateRange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomViewType = .dateRange
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Private methods
    private func setup() {

        setupUI()
    }
    
    private func setupUI() {
    }
    
    private func setupTableConfiguration() {
        
    }
    
    private func reloadData() {

    }
}

extension InvestorDashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

