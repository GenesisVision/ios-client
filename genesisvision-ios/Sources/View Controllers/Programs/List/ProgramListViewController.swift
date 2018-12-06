//
//  ProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    
    // MARK: - View Model
    var viewModel: ListViewModel!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupSignInButton()
            setupTableConfiguration()
        }
    }
    
    var ratingTableHeaderView: RatingTableHeaderView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        signInButtonEnable = viewModel.signInButtonEnable
        signInButton.isHidden = !signInButtonEnable
    }
    
    private func setup() {
        registerForPreviewing()
        
        setupUI()
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        navigationItem.title = viewModel.title
        
        bottomViewType = viewModel.bottomViewType
        
        if signInButtonEnable {
            showNewVersionAlertIfNeeded(self)
        }
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = signInButtonEnable ? 82.0 : 0.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        if viewModel.canPullToRefresh {
            setupPullToRefresh(scrollView: tableView)
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()

            UIView.setAnimationsEnabled(false)
            self.tableView?.reloadData()
            UIView.setAnimationsEnabled(true)
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
        
        showProgressHUD()
        fetch()
    }
}

extension ProgramListViewController {
    override func filterButtonAction() {
        viewModel.showFilterVC(filterType: .programs, sortingType: .programs)
    }
    
    override func signInButtonAction() {
        viewModel.showSignInVC()
    }
}

extension ProgramListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.modelsCount() >= indexPath.row else {
            return
        }
        
        viewModel.showDetail(at: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.filterModel.levelUpData != nil {
            return 60.0
        }
        
        return 0
        
//        switch viewModel.assetType {
//        case .rating:
//            return 60.0
//        default:
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let levelUpData = viewModel.filterModel.levelUpData {
            let header = tableView.dequeueReusableHeaderFooterView() as RatingTableHeaderView
            header.configure(levelUpData)
            
            ratingTableHeaderView = header
            
            return ratingTableHeaderView
        }
        
        return nil
//        switch viewModel.assetType {
//        case .rating:
//            let header = tableView.dequeueReusableHeaderFooterView() as RatingTableHeaderView
//            if let levelUpData = viewModel.filterModel.levelUpData {
//                header.configure(levelUpData)
//            }
//
//            ratingTableHeaderView = header
//
//            return ratingTableHeaderView
//        default:
//            return nil
//        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}


// MARK: - UIViewControllerPreviewingDelegate
extension ProgramListViewController: UIViewControllerPreviewingDelegate {
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
extension ProgramListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

// MARK: - FavoriteStateChangeProtocol
extension ProgramListViewController: FavoriteStateChangeProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func didChangeFavoriteState(with assetID: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, assetId: assetID, request: request) { [weak self] (result) in
            self?.hideAll()
            
            if let isFavorite = self?.viewModel?.filterModel.isFavorite, isFavorite {
                self?.fetch()
            }
        }
    }
}
