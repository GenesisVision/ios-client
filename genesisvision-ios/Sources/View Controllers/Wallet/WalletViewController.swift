//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class WalletViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: WalletControllerViewModel!
    
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
        
        updateTitle()
    }
    
    // MARK: - Private methods
    private func setup() {
        registerForPreviewing()
        
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        updateTitle()
        
    }
    
    private func updateTitle() {
        title = viewModel.title.uppercased()
        navigationItem.title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: WalletControllerViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: WalletControllerViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()

        fetchBalance()
        fetchTransactions()
    }

    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    private func updateSortHeaderView() {
        guard let title = self.viewModel.headerTitle(for: 1) else {
            return
        }
        
        let header = self.tableView.headerView(forSection: 1) as! SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        
        showProgressHUD()
        fetchTransactions()
    }
    
    override func fetch() {
        showProgressHUD()
        fetchBalance()
        fetchTransactions()
    }
    
    private func fetchBalance() {
        viewModel.fetchBalance { (result) in }
    }
    
    private func fetchTransactions() {
        viewModel.refresh { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                break
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    private func fetchMoreTransactions() {
        canFetchMoreResults = false
        viewModel.fetchMoreTransactions { [weak self] (result) in
            self?.canFetchMoreResults = true
            switch result {
            case .success:
                break
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
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
        if indexPath.section > 0, indexPath.row > 0 { cell.addDashedBottomLine() }
        
        if (viewModel.numberOfRows(in: indexPath.section) - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMoreTransactions()
        }
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

        let header = tableView.dequeueReusableHeaderFooterView() as SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        header.delegate = self

        return header
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

extension WalletViewController: WalletHeaderTableViewCellProtocol {
    func depositProgramDidPress() {
//        viewModel.deposit()
        showAlertWithTitle(title: nil, message: "Coming soon", actionTitle: "OK", cancelTitle: nil, handler: nil, cancelHandler: nil)
    }
    
    func withdrawProgramDidPress() {
//        viewModel.withdraw()
        showAlertWithTitle(title: nil, message: "Coming soon", actionTitle: "OK", cancelTitle: nil, handler: nil, cancelHandler: nil)
    }
    
    func updateBalanceDidPress() {
        fetchBalance()
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
        
        return UIImage.placeholder
    }
    
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
    
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = viewModel.noDataButtonTitle()
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.white,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 14)]

        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension WalletViewController: SortHeaderViewProtocol {
    func sortButtonDidPress() {
        showActionSheet(with: nil, message: nil, title: "All", handler: { [weak self] in
            self?.viewModel.filter?.type = .all
            self?.updateSortHeaderView()
        }, title: "Internal", handler: { [weak self] in
            self?.viewModel.filter?.type = ._internal
            self?.updateSortHeaderView()
        }, title: "External", handler: { [weak self] in
            self?.viewModel.filter?.type = .external
            self?.updateSortHeaderView()
        }, cancelTitle: "Cancel", cancelHandler: nil)
    }
}

extension WalletViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailViewController(with: indexPath),
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
