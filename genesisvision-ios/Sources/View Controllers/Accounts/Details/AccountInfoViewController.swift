
//
//  AccountInfoViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.2020.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AccountInfoViewController: ListViewController {
    
    // MARK: - View Model
    var viewModel: AccountInfoViewModel!
    
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
extension AccountInfoViewController: BaseTableViewProtocol {
    func didReload(_ indexPath: IndexPath) {
        hideHUD()
        tableView.reloadSections([indexPath.section], with: .fade)
    }
}

extension AccountInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        didReload()
    }
}
