//
//  TradesViewController.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TradesViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModel: TradesViewModelProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.allowsSelection = false
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func setup() {
        bottomViewType = viewModel.isOpenTrades ? .none : .dateRange
        noDataTitle = viewModel.noDataText()
        setupTableConfiguration()
        
        setupNavigationBar()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadDataSmoothly()
        }
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
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
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?) {
        viewModel.dateFrom = dateFrom
        viewModel.dateTo = dateTo
        
        showProgressHUD()
        fetch()
    }
}

extension TradesViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}
