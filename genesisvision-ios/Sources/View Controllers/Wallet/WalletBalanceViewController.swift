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
    
    @IBOutlet weak var topUpButton: ActionButton! {
        didSet {
            topUpButton.backgroundColor = UIColor.primary.withAlphaComponent(0.1)
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
            topUpButton.setEnabled(viewModel.wallet?.isDepositEnabled ?? false)
        default:
            addFundsButton.isHidden = true
            withdrawButton.isHidden = true
            topUpButton.isHidden = true
        }
        
        if let currency = viewModel.wallet?.currency, (currency == .gvt || currency == .bnb) {
            topUpButton.isHidden = true
        }
        
        if let currency = viewModel.wallet?.currency, currency == .dai {
            addFundsButton.isHidden = true
            withdrawButton.isHidden = true
            topUpButton.isHidden = true
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
            self.tableView?.reloadDataSmoothly()
        }
    }
    
    override func fetch() {
        showProgressHUD()
        viewModel.fetch()
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        if let currency = viewModel.wallet?.currency, currency == .bnb {
            showAlertWithTitle(title: "", message: "Please ensure that the withdrawal address supports the Binance Smart Chain network (BSC). You will lose your assets if your choosen platform does not support BSC.", actionTitle: "I understand it", cancelTitle: nil, handler: { [weak self] in
                self?.viewModel.withdraw()
            }, cancelHandler: nil)
        } else {
            viewModel.withdraw()
        }
    }
    
    @IBAction func depositButtonAction(_ sender: UISwitch) {
        if let currency = viewModel.wallet?.currency, currency == .bnb {
            showAlertWithTitle(title: "", message: "Please ensure that you are using Binance Smart Chain network (BSC) when depositing BNB to this address. You will lose your assets if you do not choose the correct network.", actionTitle: "I understand it", cancelTitle: nil, handler: { [weak self] in
                self?.viewModel.deposit()
            }, cancelHandler: nil)
        } else {
            viewModel.deposit()
        }
    }
    
    @IBAction func transferButtonAction(_ sender: UIButton) {
        viewModel.transfer()
    }
    
    @IBAction func butWithCardButtonAction(_ sender: Any) {
        viewModel.topUp()
    }
}

extension WalletBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath) else {
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
