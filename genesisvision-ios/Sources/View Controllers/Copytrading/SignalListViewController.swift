//
//  SignalListViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class SignalListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - View Model
    var viewModel: SignalListViewModel!
    var firstTimeSetup3dTouch: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel.signalListDelegateManager.delegate = self
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
        tableView.delegate = self.viewModel?.signalListDelegateManager
        tableView.dataSource = self.viewModel?.signalListDelegateManager
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
}

extension SignalListViewController {
    override func filterButtonAction() {
        viewModel?.showFilterVC()
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension SignalListViewController: UIViewControllerPreviewingDelegate {
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
extension SignalListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

// MARK: - FavoriteStateChangeProtocol
extension SignalListViewController: FavoriteStateChangeProtocol {
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

extension SignalListViewController: DelegateManagerProtocol {
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

extension SignalListViewController {
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        viewModel.showProgramList()
    }
}

