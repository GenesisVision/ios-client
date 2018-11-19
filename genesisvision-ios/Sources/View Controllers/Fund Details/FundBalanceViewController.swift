//
//  FundBalanceViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class FundBalanceViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: FundBalanceViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.hideHeader()
    }
    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
        
        showInfiniteIndicator(value: false)
    }
    
    private func setup() {
        bottomViewType = .dateRange
        setupTableConfiguration()
        
        setupNavigationBar()
        
        showProgressHUD()
        fetch()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
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

extension FundBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath.row) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}

extension FundBalanceViewController: ChartViewProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func chartValueNothingSelected() {
        tableView.isScrollEnabled = true
        tableView.panGestureRecognizer.isEnabled = true
    }
    
    func chartValueSelected(date: Date) {
        tableView.isScrollEnabled = false
        tableView.panGestureRecognizer.isEnabled = false
    }
}

extension FundBalanceViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}
