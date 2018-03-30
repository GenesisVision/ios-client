//
//  TournamentListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TournamentListViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: TournamentListViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.showsCancelButton = false
            searchBar.isTranslucent = true
            searchBar.backgroundColor = UIColor.Background.main
            searchBar.barTintColor = UIColor.primary
            searchBar.tintColor = UIColor.primary
            searchBar.placeholder = "Search"
        }
    }
    
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
    }
    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: TournamentListViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: TournamentListViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func setup() {
        registerForPreviewing()
        
        title = viewModel.title
        showProgressHUD()
        fetch()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func fetchMore() {
        canFetchMoreResults = false
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            switch result {
            case .success:
                self?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension TournamentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.modelsCount() >= indexPath.row else {
            return
        }
        
        guard let participantViewModel = viewModel.model(for: indexPath.row)?.participantViewModel else { return }
        
        viewModel.showDetail(with: participantViewModel)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { cell.addDashedBottomLine() }
        
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
        header.headerLabel.font = UIFont.getFont(.regular, size: 15)
        header.headerLabel.text = title
        header.headerLabel.textColor = UIColor.Font.medium
        return header
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}


extension TournamentListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailViewController(with: indexPath.row),
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

extension TournamentListViewController {
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = viewModel.noDataText()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.noDataPlaceholder
    }
}

extension TournamentListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty && searchText != viewModel.searchText || searchText.isEmpty && !viewModel.searchText.isEmpty else {
            return
        }
        
        viewModel.searchText = searchText
        
        updateData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        
        searchBar.text = ""
        
        guard let searchText = searchBar.text, !viewModel.searchText.isEmpty else {
            return
        }
    
        viewModel.searchText = searchText
        
        updateData()
    }
}

