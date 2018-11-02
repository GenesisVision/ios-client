//
//  DashboardProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George on 20/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardProgramListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: DashboardProgramListViewModel!
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
        viewModel.programListDelegateManager.delegate = self
        register3dTouch()
        setupUI()
        
        showProgressHUD()
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        setupTableConfiguration()
        
        let sortTitle = self.viewModel?.sortingDelegateManager.sortingManager?.sortTitle()
        sortButton.setTitle(sortTitle, for: .normal)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = 60
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.delegate = self.viewModel?.programListDelegateManager
        tableView.dataSource = self.viewModel?.programListDelegateManager
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
    
    func showFilterVC() {
//        router.show(routeType: .showFilterVC(programListViewModel: self as! ProgramListViewModel))
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
}

extension DashboardProgramListViewController {
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
    func didChangeFavoriteState(with assetId: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, assetId: assetId, request: request) { [weak self] (result) in
            self?.hideAll()
        }
    }
}

extension DashboardProgramListViewController: SortingDelegate {
    func didSelectSorting() {
        bottomSheetController.dismiss()
        
        showProgressHUD()
        fetch()
    }
}

extension DashboardProgramListViewController: DelegateManagerProtocol {
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

extension DashboardProgramListViewController: ReinvestProtocol {
    func didChangeReinvestSwitch(value: Bool, assetId: String) {
        viewModel.didChangeReinvestSwitch(value: value, assetId: assetId)
    }
}


extension DashboardProgramListViewController {
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
}
