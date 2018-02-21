//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ViewAnimator

class WalletViewController: BaseViewControllerWithTableView {

    // MARK: - Variables
    private var canFetchMoreResults = true
    private var withdrawBarButtonItem: UIBarButtonItem?
    private let tableViewAnimation = AnimationType.from(direction: .right, offset: 30.0)
    
    // MARK: - View Model
    var viewModel: WalletViewModel!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.title
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        withdrawBarButtonItem = UIBarButtonItem(title: "Withdraw", style: .done, target: self, action: #selector(withdrawButtonAction(_:)))
        navigationItem.rightBarButtonItem = withdrawBarButtonItem
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: WalletViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: WalletViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchBalance()
        fetchTransactions()
    }

    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.animateViews(animations: [tableViewAnimation])
    }
    
    private func fetch() {
        showProgressHUD()
        fetchBalance()
        fetchTransactions()
    }
    
    private func fetchBalance() {
        viewModel.fetchBalance { (result) in
        }
    }
    
    private func fetchTransactions() {
        viewModel.fetchTransactions { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    private func fetchMoreTransactions() {
        self.canFetchMoreResults = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.viewModel.fetchMoreTransactions { [weak self] (result) in
            self?.canFetchMoreResults = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success:
                self?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        viewModel.withdraw()
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
        header.headerLabel.text = title
        return header
    }
}
