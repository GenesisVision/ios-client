//
//  AssetsListViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 09.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit


class CoinAssetsListViewController : BaseViewControllerWithTableView {
    
    private var signInButtonEnable: Bool = false
    
    var viewModel: ListViewModel!
    weak var searchProtocol: SearchViewControllerProtocol?
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.assetListDelegateManager.delegate = self
        registerForPreviewing()
    
        setupUI()
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = signInButtonEnable ? 82.0 : 0.0
        
        tableView.delegate = self.viewModel?.assetListDelegateManager
        tableView.dataSource = self.viewModel?.assetListDelegateManager
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        if viewModel.canPullToRefresh {
            setupPullToRefresh(scrollView: tableView)
        }
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        navigationItem.title = viewModel.title
        
        bottomViewType = searchProtocol == nil ? viewModel.bottomViewType : .none
        
        if signInButtonEnable {
            showNewVersionAlertIfNeeded(self)
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadDataSmoothly()
        }
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
            
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
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?, dateRangeType: DateRangeType? = nil) {
        showProgressHUD()
        fetch()
    }
    
}

extension CoinAssetsListViewController {
    override func filterButtonAction() {
        viewModel.showFilterVC(listViewModel: viewModel, filterModel: viewModel.filterModel, filterType: .coinAsset, sortingType: .assets)
    }
    
    override func signInButtonAction() {
        viewModel.showSignInVC()
    }
}


// MARK: - ReloadDataProtocol
extension CoinAssetsListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}

extension CoinAssetsListViewController: DelegateManagerProtocol {
    func delegateManagerTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel.model(for: indexPath) as? ProgramTableViewCellViewModel, let assetId = model.asset._id?.uuidString {
            searchProtocol?.didSelect(assetId, assetType: .program)
        } else if let model = viewModel.model(for: indexPath) as? FollowTableViewCellViewModel, let assetId = model.asset._id?.uuidString {
            searchProtocol?.didSelect(assetId, assetType: .follow)
        }
    }
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

// MARK: - UIViewControllerPreviewingDelegate
extension CoinAssetsListViewController: UIViewControllerPreviewingDelegate {
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

// MARK: - FavoriteStateChangeProtocol
extension CoinAssetsListViewController: FavoriteStateChangeProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func didChangeFavoriteState(with assetID: String, value: Bool, request: Bool) {
        viewModel.changeFavorite(value: value, assetId: assetID, request: request) { [weak self] (result) in
            self?.hideAll()
            
            if let isFavorite = self?.viewModel?.filterModel.isFavorite, isFavorite {
                self?.fetch()
            }
        }
    }
}
