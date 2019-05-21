//
//  WalletCopytradingAccountListViewController.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletCopytradingAccountListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: WalletCopytradingAccountListViewModel!
    
    // MARK: - Views
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var transferButton: ActionButton! {
        didSet {
            transferButton.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        showInfiniteIndicator(value: false)
        
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        bottomViewType = .none
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    override func fetch() {
        showProgressHUD()
        viewModel.fetch()
    }
}

extension WalletCopytradingAccountListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else { return }
        
        viewModel.showAccount(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.BaseView.bg
        }
    }
}

extension WalletCopytradingAccountListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
    }
}
