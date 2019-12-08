//
//  WalletTransactionListViewController.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTransactionListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: WalletListViewModelProtocol!
    
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
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        navigationTitleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        addCurrencyTitleButton(CurrencyDelegateManager())
        
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

        viewModel.refresh { (result) in }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    override func fetch() {
//        showProgressHUD()
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            if let totalCount = self?.viewModel.totalCount {
                self?.tabmanBarItems?.forEach({ $0.badgeValue = "\(totalCount)" })
            }
        }
    }
    
    private func openTransictionDetails(_ details: TransactionDetails, uuid: UUID) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 450
        bottomSheetController.lineViewIsHidden = true
        
        let view = WalletTransactionView.viewFromNib()
        view.configure(details, uuid: uuid)
        view.delegate = self
        bottomSheetController.addContentsView(view)
        bottomSheetController.present()
    }
    
    private func showTransaction(_ uuid: UUID) {
        showProgressHUD()
        WalletDataProvider.getTransactionDetails(with: uuid, completion: { [weak self] (details) in
            self?.hideAll()
            
            if let details = details {
                self?.openTransictionDetails(details, uuid: uuid)
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
}

extension WalletTransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else { return }

        if let model = viewModel.model(at: indexPath) as? WalletTransactionTableViewCellViewModel, let uuid = model.walletTransaction.id {
            showTransaction(uuid)
        } else if let model = viewModel.model(at: indexPath) as? WalletExternalTransactionTableViewCellViewModel, let uuid = model.walletTransaction.id {
            showTransaction(uuid)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath))
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

extension WalletTransactionListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}

extension WalletTransactionListViewController: WalletTransactionViewProtocol {
    func copyAddressButtonDidPress(_ address: String) {
        bottomSheetController.dismiss()

        UIPasteboard.general.string = address
        showBottomSheet(.success, title: String.Info.walletCopyAddress)
    }
    
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func resendButtonDidPress(_ uuid: UUID) {
        bottomSheetController.dismiss()
        showProgressHUD()
        WalletDataProvider.resendWithdrawalRequest(with: uuid) { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.showBottomSheet(.success, title: String.Info.walletEmailSent)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    func cancelButtonDidPress(_ uuid: UUID) {
        bottomSheetController.dismiss()
        showProgressHUD()
        WalletDataProvider.cancelWithdrawalRequest(with: uuid) { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.showBottomSheet(.success, title: String.Info.withdrawalCanceled)
                self?.viewModel.refresh { (result) in }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
}
