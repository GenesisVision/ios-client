//
//  DashboardProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George on 20/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardProgramListViewController: BaseViewControllerWithTableView {
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    // MARK: - View Model
    var viewModel: DashboardProgramListViewModel!
    var firstTimeSetup3dTouch: Bool = false
    
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
        viewModel.programListDelegateManager.delegate = self
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
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = 60.0
        
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.delegate = self.viewModel?.programListDelegateManager
        tableView.dataSource = self.viewModel?.programListDelegateManager
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        if viewModel.canPullToRefresh {
            setupPullToRefresh(scrollView: tableView)
        }
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
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?) {
        viewModel.filterModel.dateRangeModel.dateFrom = dateFrom
        viewModel.filterModel.dateRangeModel.dateTo = dateTo
    }
}

extension DashboardProgramListViewController {
    override func filterButtonAction() {
        viewModel?.showFilterVC()
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension DashboardProgramListViewController: UIViewControllerPreviewingDelegate {
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
extension DashboardProgramListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

// MARK: - FavoriteStateChangeProtocol
extension DashboardProgramListViewController: FavoriteStateChangeProtocol {
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

extension DashboardProgramListViewController: DelegateManagerProtocol {
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath))
    }
    
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
}

extension DashboardProgramListViewController: SwitchProtocol {
    func didChangeSwitch(value: Bool, assetId: String) {
        viewModel.didChangeSwitch(value: value, assetId: assetId)
    }
}

extension DashboardProgramListViewController {
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
}

extension DashboardProgramListViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        guard let tabsType = TabsType(rawValue: tabBarIndex) else { return }
        switch tabsType {
        case .dashboard:
            tableView.setContentOffset(.zero, animated: true)
        default:
            break
        }
    }
}
