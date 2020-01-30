//
//  ManagerInfoViewController.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ManagerInfoViewController: ListViewController {
    
    // MARK: - View Model
    var viewModel: ManagerInfoViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        showProgressHUD()
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        tableView.configure(with: .defaultConfiguration)

        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    // MARK: - Public methods
    func updateDetails(with managerProfileDetails: PublicProfile) {
        viewModel.updateDetails(with: managerProfileDetails)
        didReload()
    }
    
    func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            self?.didReload()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}
extension ManagerInfoViewController: BaseTableViewProtocol {
    
}

extension ManagerInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        didReload()
    }
}
