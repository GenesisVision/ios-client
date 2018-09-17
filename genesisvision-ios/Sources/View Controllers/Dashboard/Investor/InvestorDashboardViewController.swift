//
//  InvestorDashboardViewController.swift
//  genesisvision-ios
//
//  Created by George on 27/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class InvestorDashboardViewController: DashboardViewController {
    
    // MARK: - Variables
    private var bottomSheetController = BottomSheetController()
    private var dateRangeView: DateRangeView!
    
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
    }
    
    // MARK: - Private methods
    private func setup() {
        setupTableConfiguration()
        registerForPreviewing()
        
        setupUI()
    }
    
    private func setupUI() {
        bottomViewType = viewModel.bottomViewType
        sortButton.setTitle(self.viewModel?.sortingDelegateManager.sortTitle(), for: .normal)
        
        let currencyBarButtonItem = UIBarButtonItem(title: "BTC", style: .done, target: self, action: #selector(currencyButtonAction))
        let notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_program_read_more"), style: .done, target: self, action: #selector(notificationsButtonAction))

        navigationItem.leftBarButtonItems = [notificationsBarButtonItem, currencyBarButtonItem]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Week", style: .done, target: self, action: #selector(dateRangeButtonAction))
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
        //update daterange and fetch
//        fetch()
    }
    
    override func sortButtonAction() {
        sortMethod()
    }
    
    // MARK: - Actions
    private func sortMethod() {
        bottomSheetController = BottomSheetController()

        bottomSheetController.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High", buttonAction: #selector(highToLowButtonAction), buttonTarget: self, buttonSelected: viewModel.highToLowValue)
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.delegate = self?.viewModel.sortingDelegateManager
            tableView.dataSource = self?.viewModel.sortingDelegateManager
            tableView.separatorStyle = .none
        }
        
        viewModel.sortingDelegateManager.tableViewProtocol = self
        bottomSheetController.present()
    }
    
    @objc func currencyButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("Preferred Currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            if let currencyCellModelsForRegistration = self?.viewModel.currencyCellModelsForRegistration {
                tableView.registerNibs(for: currencyCellModelsForRegistration)
            }
            tableView.delegate = self?.viewModel.currencyDelegateManager
            tableView.dataSource = self?.viewModel.currencyDelegateManager
            tableView.separatorStyle = .none
        }
        
        viewModel.currencyDelegateManager.tableViewProtocol = self
        bottomSheetController.present()
    }
    
    @objc func highToLowButtonAction() {
        viewModel.highToLowValue = !viewModel.highToLowValue
        bottomSheetController.dismiss()
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationList()
    }
    
    @objc func dateRangeButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 379
        
        dateRangeView = DateRangeView.viewFromNib()
        bottomSheetController.addContentsView(dateRangeView)
        dateRangeView.delegate = self
        bottomSheetController.present()
    }
}

extension InvestorDashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

extension InvestorDashboardViewController: SortingDelegate {
    func didSelectSorting(at indexPath: IndexPath) {
        bottomSheetController.dismiss()
    }
}

extension InvestorDashboardViewController: CurrencyDelegate {
    func didSelectCurrency(at indexPath: IndexPath) {
        bottomSheetController.dismiss()
    }
}

extension InvestorDashboardViewController: DateRangeViewProtocol {
    func applyButtonDidPress(with dateRangeType: DateRangeType, dateRangeFrom: Date, dateRangeTo: Date) {
        viewModel.dateRangeFrom = dateRangeFrom
        viewModel.dateRangeTo = dateRangeTo
        viewModel.dateRangeType = dateRangeType
//        fetch()
    }

    func showDatePicker(with dateRangeFrom: Date?, dateRangeTo: Date) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.primary

        if let dateRangeFrom = dateRangeFrom {
            alert.addDatePicker(mode: .date, date: dateRangeFrom, minimumDate: nil, maximumDate: dateRangeTo.previousDate()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateRangeFrom = date
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateRangeTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateRangeTo = date
                }
            }
        }

        alert.addAction(title: "Done", style: .cancel)
        bottomSheetController.present(viewController: alert)
    }
}
