//
//  WalletListViewController.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: WalletListViewModel!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarDidScrollToTop(_:)), name: .tabBarDidScrollToTop, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
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
        
        if viewModel.walletType == .wallet {
            transferButton.isHidden = false
            tableView.contentInset.bottom = 82.0
        }
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
    
    // MARK: - Actions
    @IBAction func transferButtonAction(_ sender: UIButton) {
        viewModel.transfer()
    }
}

extension WalletListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else { return }

        viewModel.showWallet(at: indexPath)
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

extension WalletListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
    }
}
