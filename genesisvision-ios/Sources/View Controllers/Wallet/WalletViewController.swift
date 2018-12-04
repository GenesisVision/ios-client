//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: WalletControllerViewModel!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    var walletTableHeaderViewHeightStart: CGFloat = 300.0
    var walletTableHeaderViewHeight: CGFloat = 300.0
    var walletTableHeaderViewHeightEnd: CGFloat = 100.0
    
    var walletTableHeaderView: WalletTableHeaderView?
    
    private var withdrawBarButtonItem: UIBarButtonItem!
    private var addFundsBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTitle()
    }
    
    // MARK: - Private methods
    private func setup() {
//        registerForPreviewing()

        setupUI()
        fetch()
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        navigationTitleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        addCurrencyTitleButton(CurrencyDelegateManager())
        
        bottomViewType = .none
        
        updateTitle()
    
        withdrawBarButtonItem = UIBarButtonItem(title: "Withdraw", style: .done, target: self, action: #selector(withdrawButtonAction))
        addFundsBarButtonItem = UIBarButtonItem(title: "Add funds", style: .done, target: self, action: #selector(addFundsButtonAction))
        addFundsBarButtonItem.tintColor = UIColor.primary
    
        navigationItem.leftBarButtonItem = withdrawBarButtonItem
        navigationItem.rightBarButtonItem = addFundsBarButtonItem
    }
    
    @objc private func withdrawButtonAction() {
        viewModel.withdraw()
    }
    
    @objc private func addFundsButtonAction() {
        viewModel.deposit()
    }
    
    private func updateTitle() {
        navigationItem.title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()

        fetchBalance()
        fetchTransactions()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }

    override func fetch() {
        showProgressHUD()
        fetchBalance()
        fetchTransactions()
    }
    
    private func fetchBalance() {
        viewModel.fetchBalance { [weak self] (result) in
            self?.reloadData()
        }
    }
    
    private func fetchTransactions() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func showWalletTransaction(model: WalletTransaction) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300
        
        let view = WalletTransactionView.viewFromNib()
        view.configure(model)
        bottomSheetController.addContentsView(view)
        bottomSheetController.present()
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else { return }
        
        guard let model = viewModel.model(at: indexPath) as? WalletTransactionTableViewCellViewModel else { return }
        
        showWalletTransaction(model: model.walletTransaction)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMoreTransactions(at: indexPath.row))
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return walletTableHeaderViewHeight
        default:
            return viewModel.headerHeight(for: section)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView() as WalletTableHeaderView
            if let wallet = viewModel.wallet {
                header.configure(wallet)
            }
            
            walletTableHeaderView = header
            
            return walletTableHeaderView
        case 1:
            guard let title = viewModel.headerTitle(for: section) else {
                return nil
            }
            
            let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
            header.headerLabel.text = title
            return header
        default:
            return nil
        }
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationTitleView?.scrollViewDidScroll(scrollView, threshold: -30.0)
    }
}

extension WalletViewController: WalletProtocol {
    func didWithdrawn() {
        reloadData()
    }
}

extension WalletViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}
