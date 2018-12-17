//
//  DashboardFundListViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardFundListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: DashboardFundListViewModel!
    var firstTimeSetup3dTouch: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel.fundListDelegateManager.delegate = self
        register3dTouch()
        setupUI()
        
        showProgressHUD()
    }
    
    private func setupUI() {
        bottomViewType = viewModel.bottomViewType
        bottomStackViewHiddable = false
        
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        setupTableConfiguration()
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)

        tableView.isScrollEnabled = false
        tableView.bounces = true
        tableView.delegate = self.viewModel?.fundListDelegateManager
        tableView.dataSource = self.viewModel?.fundListDelegateManager
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Public methods
    override func register3dTouch() {
        if !firstTimeSetup3dTouch {
            firstTimeSetup3dTouch = registerForPreviewing()
        }
    }
    
    override func fetch() {
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
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension DashboardFundListViewController {
    override func filterButtonAction() {
        viewModel?.showFilterVC()
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension DashboardFundListViewController: UIViewControllerPreviewingDelegate {
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

// MARK: - ReloadDataProtocol
extension DashboardFundListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

// MARK: - FavoriteStateChangeProtocol
extension DashboardFundListViewController: FavoriteStateChangeProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func didChangeFavoriteState(with assetId: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, assetId: assetId, request: request) { [weak self] (result) in
            self?.hideAll()
        }
    }
}

extension DashboardFundListViewController: DelegateManagerProtocol {
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath.row))
    }
    
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
}

extension DashboardFundListViewController {
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showFundList()
    }
}
