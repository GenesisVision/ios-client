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
        
//        showProgressHUD()
//        setup()
        
//        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Private methods
    private func setup() {
        scrollView.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
    }
    
    private func setupTableConfiguration() {
        
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            //TODO: update all views: charts, events, assets
        }
    }
    
//    override func fetch() {
//        viewModel.refresh { [weak self] (result) in
//            self?.hideAll()
//
//            switch result {
//            case .success:
//                self?.reloadData()
//            case .failure(let errorType):
//                ErrorHandler.handleError(with: errorType, viewController: self)
//            }
//        }
//    }
    
//    override func pullToRefresh() {
//        super.pullToRefresh()
//        hideAll()
//        //update daterange and fetch
////        fetch()
//    }
}

extension InvestorDashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

