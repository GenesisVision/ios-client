//
//  ProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ViewAnimator

class ProgramListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    private var filterBarButtonItem: UIBarButtonItem?
    private let tableViewAnimation = AnimationType.from(direction: .right, offset: 30.0)
    
    // MARK: - View Model
    var viewModel: InvestmentProgramListViewModel! {
        didSet {
            pullToRefresh()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var signInButton: UIButton!
    
    // MARK: - Outlets
    @IBOutlet weak var signInButtonViewHeightConstraint: NSLayoutConstraint!
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
            setupSignInButton()
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        signInButtonEnable = viewModel.signInButtonEnable()
        
        signInButtonViewHeightConstraint.constant = signInButtonEnable ? 76.0 : 0.0
        signInButton.isHidden = !signInButtonEnable
    }
    
    private func setupTableConfiguration() {
        var tableViewConfiguration: TableViewConfiguration = .defaultConfig
        tableViewConfiguration.bottomInset = signInButtonEnable ? 76.0 + 16.0 : 0.0
        tableView.configure(with: .custom(tableViewConfiguration))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: InvestmentProgramListViewModel.cellModelsForRegistration)

        setupPullToRefresh()
    }
    
    private func setup() {
        registerForPreviewing()
        
        showProgressHUD()
        setupUI()
    }
    
    private func setupUI() {
        filterBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterButtonAction(_:)))
        navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.animateViews(animations: [tableViewAnimation])
    }
    
    override func fetchMore() {
        canFetchMoreResults = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success:
                self?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    override func pullToRefresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        viewModel.refresh { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        viewModel.showSignInVC()
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        viewModel.showFilterVC()
    }
}

extension ProgramListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.modelsCount() >= indexPath.row else {
            return
        }
        
        guard let investmentProgram = viewModel.model(for: indexPath.row)?.investmentProgram else {
            return
        }

        viewModel.showDetail(with: investmentProgram.id?.uuidString ?? "")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath.row) else {
            return UITableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }

    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}


extension ProgramListViewController: UIViewControllerPreviewingDelegate {
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

extension ProgramListViewController: UISearchBarDelegate {
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
