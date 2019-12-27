//
//  WalletBalanceViewController.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletBalanceViewController: BaseViewControllerWithTableView {
    // MARK: - Variables
    var viewModel: WalletBalanceViewModel!
    
    // MARK: - Views
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var addFundsButton: ActionButton! {
        didSet {
            addFundsButton.backgroundColor = UIColor.primary.withAlphaComponent(0.1)
        }
    }
    @IBOutlet weak var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.configure(with: .darkClear)
        }
    }
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
        
        switch viewModel.walletType {
        case .wallet:
            tableView.contentInset.bottom = 82.0
            
            addFundsButton.setEnabled(viewModel.wallet?.isDepositEnabled ?? false)
            withdrawButton.setEnabled(viewModel.wallet?.isWithdrawalEnabled ?? false)
        default:
            addFundsButton.isHidden = true
            withdrawButton.isHidden = true
        }
    }
    
    @objc private func withdrawButtonAction() {
        viewModel.withdraw()
    }
    
    @objc private func addFundsButtonAction() {
        viewModel.deposit()
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
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        viewModel.withdraw()
    }
    
    @IBAction func depositButtonAction(_ sender: UISwitch) {
        viewModel.deposit()
    }
    
    @IBAction func transferButtonAction(_ sender: UIButton) {
        viewModel.transfer()
    }
}

extension WalletBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

extension WalletBalanceViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
    }
}
