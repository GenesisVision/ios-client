//
//  AssetsListViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 09.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit


class CoinAssetsListViewController : BaseViewControllerWithTableView {
    
    private var signInButtonEnable: Bool = false
    
    var viewModel: ListViewModel!
    weak var searchProtocol: SearchViewControllerProtocol?
    
    @IBOutlet weak var AssetsListTableView: UITableView! {
        didSet {
//            setupTableConfiguration()
//            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableConfiguration()
//        setup()
    }
    
    private func setup() {
//        viewModel.assetListDelegateManager.delegate = self
//        registerForPreviewing()
        
//        setupUI()
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = signInButtonEnable ? 82.0 : 0.0
        
        tableView.delegate = self.viewModel?.assetListDelegateManager
        tableView.dataSource = self.viewModel?.assetListDelegateManager
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        if viewModel.canPullToRefresh {
            setupPullToRefresh(scrollView: tableView)
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadDataSmoothly()
        }
    }
    
}


// MARK: - ReloadDataProtocol
extension CoinAssetsListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}
