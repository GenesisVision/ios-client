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
        
        showProgressHUD()
        setup()
        
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for visibleCell in tableView.visibleCells {
            if let cell = visibleCell as? DashboardTableViewCell {
                cell.stopTimer()
            }
        }
    }
    
    // MARK: - Private methods
    private func setup() {
//        title = viewModel.title
        setupTableConfiguration()
        registerForPreviewing()
        
        setupUI()
    }
    
    private func setupUI() {
        bottomViewType = viewModel.bottomViewType
        sortButton.setTitle(self.viewModel.sortTitle(), for: .normal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BTC", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Week", style: .done, target: self, action: nil)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    private func updateSortView() {
        sortButton.setTitle(self.viewModel.sortTitle(), for: .normal)
        
        showProgressHUD()
        fetch()
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
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
        hideAll()
//        fetch()
    }
    
    override func sortButtonAction() {
        sortMethod()
    }
    
    // MARK: - Actions
    @objc func sortMethod() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.primary
        
        var selectedIndexRow = viewModel.getSelectedSortingIndex()
        let values = viewModel.sortingValues
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
        
        let applyAction = UIAlertAction(title: "Apply", style: .default) { [weak self] (action) in
            guard selectedIndexRow != self?.viewModel.getSelectedSortingIndex() else { return }
            
            self?.viewModel.changeSorting(at: selectedIndexRow)
            self?.updateSortView()
        }
        
        applyAction.isEnabled = false
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            
            guard index.row != self?.viewModel.getSelectedSortingIndex() else {
                return applyAction.isEnabled = false
            }
            
            applyAction.isEnabled = true
            selectedIndexRow = index.row
        }
        
        alert.addAction(applyAction)
        
        alert.addAction(title: "Cancel", style: .cancel)
        
        alert.show()
    }
}

extension InvestorDashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}
