////
////  CreateFundAssetsListViewController.swift
////  genesisvision-ios
////
////  Created by Ruslan Lukin on 19.07.2020.
////  Copyright © 2020 Genesis Vision. All rights reserved.
////
//
//import UIKit
//
//class CreateFundAssetsListViewController: BaseViewControllerWithTableView {
//    
//    @IBOutlet override var tableView: UITableView! {
//        didSet {
//            setupTableConfiguration()
//        }
//    }
//    
//    var viewModel: AddAssetListViewModel!
//    
//    private func setupTableConfiguration() {
//        tableView.configure(with: .defaultConfiguration)
//        tableView.contentInset.bottom = 0.0
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
//        
//        if viewModel.canPullToRefresh {
//            setupPullToRefresh(scrollView: tableView)
//        }
//    }
//    
//    private func reloadData() {
//        DispatchQueue.main.async {
//            self.refreshControl?.endRefreshing()
//            self.tableView?.reloadDataSmoothly()
//        }
//    }
//    
//    override func fetch() {
//        viewModel.refresh { [weak self] (result) in
//            self?.hideAll()
//            
//            switch result {
//            case .success:
//                break
//            case .failure(let errorType):
//                ErrorHandler.handleError(with: errorType, viewController: self)
//            }
//        }
//    }
//}
//
//extension CreateFundAssetsListViewController: UITableViewDelegate, UITableViewDataSource  {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}
