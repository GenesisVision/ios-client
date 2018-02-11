//
//  TraderListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TraderListViewController: BaseViewControllerWithTableView {

    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    private var canFetchMoreResults = true
    private var refreshControl: UIRefreshControl!
    private var filterBarButtonItem: UIBarButtonItem?
    
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
        
        signInButtonViewHeightConstraint.constant = !signInButtonEnable ? 0.0 : 76.0
        signInButton.isHidden = !signInButtonEnable
    }
    
    private func setupTableConfiguration() {
        var tableViewConfiguration: TableViewConfiguration = .defaultConfig
        tableViewConfiguration.bottomInset = !signInButtonEnable ? 0.0 : 76.0 + 16.0
        tableView.configure(with: .custom(tableViewConfiguration))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNibs(for: InvestmentProgramListViewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func setupPullToRefresh() {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: attributes)
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
    
    private func fetchMore() {
        self.canFetchMoreResults = false
        
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure:
                break
            }
        }
    }
    
    @objc private func pullToRefresh() {
        viewModel.refresh { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
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

extension TraderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.programsCount() >= indexPath.row else {
            return
        }
        
        guard let programEntity = viewModel.program(for: indexPath.row)?.investmentProgramEntity else {
            return
        }

        viewModel.showProgramDetail(with: programEntity)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.program(for: indexPath.row) else {
            return UITableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (viewModel.programsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }

    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}


extension TraderListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        
        guard let vc = viewModel.getProgramDetailViewController(with: indexPath.row) else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}

extension TraderListViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        showProgressHUD()
        pullToRefresh()
    }
}
