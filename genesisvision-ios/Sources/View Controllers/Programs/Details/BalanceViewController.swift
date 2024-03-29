//
//  ProgramBalanceViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class BalanceViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: ViewModelWithListProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadDataSmoothly()
        }
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?, dateRangeType: DateRangeType? = nil) {
        if var viewModel = viewModel as? ViewModelWithFilter {
            viewModel.dateFrom = dateFrom
            viewModel.dateTo = dateTo
        }
        
        dateRangeModel = FilterDateRangeModel(dateRangeType: dateRangeType ?? .month, dateFrom: dateFrom, dateTo: dateTo)
        
        showProgressHUD()
        fetch()
    }
}

extension BalanceViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let model = viewModel.model(for: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}

extension BalanceViewController: ChartViewProtocol {
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
