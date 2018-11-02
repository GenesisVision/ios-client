//
//  ManagerFundListViewController.swift
//  genesisvision-ios
//
//  Created by George on 28/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerFundListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: ManagerFundListViewModel!
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.hideHeader()
        showProgressHUD()
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel?.fundListDelegateManager.delegate = self
        setupTableConfiguration()
        registerForPreviewing()
        
        setupUI()
    }
    
    private func setupUI() {
        bottomViewType = viewModel.bottomViewType
        
        let sortTitle = self.viewModel?.sortingDelegateManager.sortingManager?.sortTitle()
        sortButton.setTitle(sortTitle, for: .normal)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = -44.0
        
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
    
    private func sortMethod() {
        guard let sortingManager = viewModel.sortingDelegateManager.sortingManager else { return }
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High", normalImage: #imageLiteral(resourceName: "img_profit_filter_icon"), selectedImage: #imageLiteral(resourceName: "img_profit_filter_desc_icon"), buttonAction: #selector(highToLowButtonAction), buttonTarget: self, buttonSelected: !sortingManager.highToLowValue)
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.separatorStyle = .none
            
            if let sortingDelegateManager = self?.viewModel.sortingDelegateManager {
                tableView.registerNibs(for: sortingDelegateManager.cellModelsForRegistration)
                tableView.delegate = sortingDelegateManager
                tableView.dataSource = sortingDelegateManager
            }
        }
        
        viewModel.sortingDelegateManager.tableViewProtocol = self
        bottomSheetController.present()
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
    
    func showFilterVC() {
//        router.show(routeType: .showFilterVC(fundListViewModel: self as! FundListViewModel))
    }
    
    // MARK: - Actions
    @objc func highToLowButtonAction() {
        if let sortingManager = viewModel.sortingDelegateManager.sortingManager {
            sortingManager.highToLowValue = !sortingManager.highToLowValue
        }
        
        bottomSheetController.dismiss()
        
        showProgressHUD()
        fetch()
    }
    
    override func updateData(with dateFrom: Date, dateTo: Date) {
        viewModel.dateFrom = dateFrom
        viewModel.dateTo = dateTo
        
        showProgressHUD()
        fetch()
    }
}

extension ManagerFundListViewController {
    override func sortButtonAction() {
        sortMethod()
    }
    
    override func filterButtonAction() {
//        if let viewModel = viewModel {
//            viewModel.showFilterVC()
//        }
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension ManagerFundListViewController: UIViewControllerPreviewingDelegate {
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
extension ManagerFundListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

extension ManagerFundListViewController: SortingDelegate {
    func didSelectSorting() {
        bottomSheetController.dismiss()
        
        showProgressHUD()
        fetch()
    }
}

// MARK: - FavoriteStateChangeProtocol
extension ManagerFundListViewController: FavoriteStateChangeProtocol {
    func didChangeFavoriteState(with assetId: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, assetId: assetId, request: request) { [weak self] (result) in
            self?.hideAll()
        }
    }
}

extension ManagerFundListViewController: DelegateManagerProtocol {
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
