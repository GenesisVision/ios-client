//
//  ManagerDashboardViewController.swift
//  genesisvision-ios
//
//  Created by George on 27/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerDashboardViewController: DashboardViewController {
    
//    // MARK: - Variables
//    private var controller = BottomSheetController()
//    private var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Active", "Archive"])
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        showProgressHUD()
//        setup()
//        
////        fetch()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        
////        for visibleCell in tableView.visibleCells {
////            if let cell = visibleCell as? DashboardTableViewCell {
////                cell.stopTimer()
////            }
////        }
//    }
//    
//    // MARK: - Private methods
//    private func setup() {
//        setupTableConfiguration()
////        registerForPreviewing()
//        
//        setupUI()
//    }
//    
//    private func setupUI() {
//        bottomViewType = viewModel.bottomViewType
//        sortButton.setTitle(self.viewModel.sortingDelegateManager.sortTitle(), for: .normal)
//        
//        segmentedControl.cornerRadius = Constants.SystemSizes.cornerSize
//        segmentedControl.tintColor = UIColor.primary
//        segmentedControl.selectedSegmentIndex = 0
//        let textAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16)]
//        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
//        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
//        navigationItem.titleView = segmentedControl
//    }
//    
//    private func setupTableConfiguration() {
////        tableView.configure(with: .defaultConfiguration)
////        tableView.delegate = self
////        tableView.dataSource = self
////        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
////
////        setupPullToRefresh()
//    }
//    
//    private func reloadData() {
////        DispatchQueue.main.async {
////            self.tableView?.reloadData()
////        }
//    }
//    
//    private func updateSortView() {
////        sortButton.setTitle(self.viewModel.sortingDelegateManager.sortTitle(), for: .normal)
//        
//        showProgressHUD()
////        fetch()
//    }
//    
////    override func fetch() {
////        viewModel.refresh { [weak self] (result) in
////            self?.hideAll()
////
////            switch result {
////            case .success:
////                self?.reloadData()
////            case .failure(let errorType):
////                ErrorHandler.handleError(with: errorType, viewController: self)
////            }
////        }
////    }
//    
////    override func pullToRefresh() {
////        super.pullToRefresh()
////
////        fetch()
////    }
////
//    override func sortButtonAction() {
//        sortMethod()
//    }
//    
//    // MARK: - Actions
//    @objc func segmentSelected(sender: UISegmentedControl) {
//        viewModel.activePrograms = sender.selectedSegmentIndex == 0
//        reloadData()
//    }
//    
//    @objc func sortMethod() {
//        controller.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High")
//        
//        controller.addTableView { [weak self] tableView in
//            tableView.delegate = self?.viewModel.sortingDelegateManager
//            tableView.dataSource = self?.viewModel.sortingDelegateManager
//            tableView.rowHeight = 100
//            tableView.estimatedRowHeight = 100
//            tableView.separatorColor = #colorLiteral(red: 0.1803921569, green: 0.2078431373, blue: 0.2352941176, alpha: 1)
//        }
//        
//        controller.present()
//    }
//}
//
//extension ManagerDashboardViewController: ReloadDataProtocol {
//    func didReloadData() {
//        reloadData()
//    }
}

