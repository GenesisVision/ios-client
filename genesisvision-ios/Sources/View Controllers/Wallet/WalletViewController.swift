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
        setupTableConfiguration()
        
        registerForPreviewing()
        
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        addCurrencyTitleButton(viewModel.currencyDelegateManager)
        
        bottomViewType = .none
        sortButton.setTitle(self.viewModel.sortTitle(), for: .normal)
        
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
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
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
    
    private func updateSortView() {
        sortButton.setTitle(self.viewModel.sortTitle(), for: .normal)
        
        showProgressHUD()
        fetchTransactions()
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
    
    private func update(sorting type: TransactionsFilter.ModelType) {
        viewModel.filter?.type = type
        updateSortView()
    }
    
    private func sortMethod() {
        guard let type: TransactionsFilter.ModelType = viewModel.filter?.type else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.primary
        
        let allAction = UIAlertAction(title: "All", style: .default) { [weak self] (UIAlertAction) in
            self?.update(sorting: .all)
        }
        let internalAction = UIAlertAction(title: "Internal", style: .default) { [weak self] (UIAlertAction) in
            self?.update(sorting: ._internal)
        }
        let externalAction = UIAlertAction(title: "External", style: .default) { [weak self] (UIAlertAction) in
            self?.update(sorting: .external)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        switch type {
        case .all:
            allAction.isEnabled = false
        case ._internal:
            internalAction.isEnabled = false
        case .external:
            externalAction.isEnabled = false
        }
        
        alert.addAction(allAction)
        alert.addAction(internalAction)
        alert.addAction(externalAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = sortButton
        alert.popoverPresentationController?.sourceRect = sortButton.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    override func sortButtonAction() {
        sortMethod()
    }
    
    // MARK: - Actions
    @IBAction func filtersButtonAction(_ sender: UIButton) {
        viewModel.filters()
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else {
            return
        }
        
        viewModel.showDetail(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
//        print(yOffset)
        if let frame = walletTableHeaderView?.frame {
            let newHeight = frame.size.height - yOffset
            if newHeight < walletTableHeaderViewHeightStart || newHeight > walletTableHeaderViewHeightEnd {
                walletTableHeaderView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newHeight)
            }
        }
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

extension WalletViewController {
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = viewModel.noDataText()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let imageName = viewModel.noDataImageName() {
            return UIImage(named: imageName)
        }
        
        return UIImage.noDataPlaceholder
    }
    
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = viewModel.noDataButtonTitle()
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.white,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 14)]

        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension WalletViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailsViewController(with: indexPath),
            let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = view.convert(cell.frame, from: tableView)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}
