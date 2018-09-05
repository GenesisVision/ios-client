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
    var controller = BottomSheetController()
    
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
    
    private func updateSortView() {
        sortButton.setTitle(self.viewModel.sortingDelegateManager.sortTitle(), for: .normal)
        
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
        controller = BottomSheetController()
        
        let btn = UIButton(type: UIButtonType.system)
        btn.isSelected = viewModel.highToLowValue
        
        let normalImage = #imageLiteral(resourceName: "img_tabbar_settings_unselected2")
        let selectedImage = #imageLiteral(resourceName: "img_textfield_password_colored_icon")
        btn.setImage(normalImage, for: .normal)
        btn.setImage(selectedImage, for: .selected)
        btn.contentHorizontalAlignment = .right
        
        let spacing = CGFloat(4)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, spacing)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, -spacing)
        
        btn.setTitle("High to Low", for: .normal)
        btn.setTitle("Low to High", for: .selected)
        btn.sizeToFit()
        
        btn.addTarget(self, action: #selector(self.highToLowButtonAction), for: .touchUpInside)
        
        controller.addNavigationbar { navigationBar in
            let item = UINavigationItem(title: "")
            
            let rightButton = UIBarButtonItem(customView: btn)
            item.rightBarButtonItem = rightButton
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.text = "Sort by"
            item.leftBarButtonItem = UIBarButtonItem(customView: label)
            navigationBar.items = [item]
        }
        
        controller.addTableView { [weak self] tableView in
            tableView.delegate = self?.viewModel.sortingDelegateManager
            tableView.dataSource = self?.viewModel.sortingDelegateManager
            tableView.rowHeight = 100
            tableView.estimatedRowHeight = 100
            tableView.separatorColor = #colorLiteral(red: 0.1803921569, green: 0.2078431373, blue: 0.2352941176, alpha: 1)
        }
        
        viewModel.sortingDelegateManager.tableViewProtocol = self
        controller.present()
    }
    
    @objc func currencyButtonAction() {
        controller = BottomSheetController()
        controller.containerViewBackgroundColor = #colorLiteral(red: 0.1450980392, green: 0.168627451, blue: 0.2, alpha: 1)
        controller.textTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        controller.viewActionType = .tappedDismiss
        controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.initializeHeight = 400
        controller.cornerRadius = 15
        
        controller.addNavigationbar { navigationBar in
            let item = UINavigationItem(title: "")
            
            let rightButton = UIBarButtonItem(title: "Button", style: .plain, target: self.controller, action: nil)
            item.rightBarButtonItem = rightButton
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.text = "Title"
            item.leftBarButtonItem = UIBarButtonItem(customView: label)
            navigationBar.items = [item]
        }
        
        controller.addTableView { [weak self] tableView in
            tableView.delegate = self?.viewModel.currencyDelegateManager
            tableView.dataSource = self?.viewModel.currencyDelegateManager
            tableView.rowHeight = 100
            tableView.estimatedRowHeight = 100
            tableView.separatorColor = #colorLiteral(red: 0.1803921569, green: 0.2078431373, blue: 0.2352941176, alpha: 1)
        }
        
        controller.present()
    }
    
    @objc func highToLowButtonAction() {
        viewModel.highToLowValue = !viewModel.highToLowValue
        controller.dismiss()
    }
    
    @objc func notificationsButtonAction() {
//        viewModel.boti
    }
    
    @objc func dateRangeButtonAction() {
        controller = BottomSheetController()
        controller.containerViewBackgroundColor = #colorLiteral(red: 0.1450980392, green: 0.168627451, blue: 0.2, alpha: 1)
        controller.textTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        controller.viewActionType = .tappedDismiss
        controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.initializeHeight = 400
        controller.cornerRadius = 15
        
        controller.addNavigationbar { navigationBar in
            let item = UINavigationItem(title: "")
            
            let rightButton = UIBarButtonItem(title: "Button", style: .plain, target: self.controller, action: nil)
            item.rightBarButtonItem = rightButton
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.text = "Title"
            item.leftBarButtonItem = UIBarButtonItem(customView: label)
            navigationBar.items = [item]
        }
        
        controller.addTableView { [weak self] tableView in
            tableView.delegate = self?.viewModel.dateRangeDelegateManager
            tableView.dataSource = self?.viewModel.dateRangeDelegateManager
            tableView.rowHeight = 100
            tableView.estimatedRowHeight = 100
            tableView.separatorColor = #colorLiteral(red: 0.1803921569, green: 0.2078431373, blue: 0.2352941176, alpha: 1)
        }
        
        controller.present()
    }
}

extension InvestorDashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

extension InvestorDashboardViewController: TableViewProtocol {
    func didSelectRow(at indexPath: IndexPath) {
        controller.dismiss()
    }
}
