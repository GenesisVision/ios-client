//
//  TraderListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TraderListViewController: BaseViewController {

    // MARK: - Variables
    private var authorizedValue: Bool = false
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
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupSignInButton()
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        
        setupUI()
        registerForPreviewing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSignInButton()
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        //if authorize status not change then return
        guard authorizedValue != viewModel.isLogin() || signInButton.isHidden != authorizedValue else {
            return
        }
        
        authorizedValue = viewModel.isLogin()
        
        signInButtonViewHeightConstraint.constant = authorizedValue ? 0.0 : 76.0
        signInButton.isHidden = authorizedValue
    }
    
    private func setupTableConfiguration() {
        //Config
        var tableViewConfiguration: TableViewConfiguration = .defaultConfig
        tableViewConfiguration.bottomInset = authorizedValue ? 0.0 : 76.0 + 16.0
        tableViewConfiguration.backgroundColor = UIColor(.lightGray)
        tableView.configure(with: .custom(tableViewConfiguration))
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNibs(for: viewModel.registerNibs())
        
        //Pull to refresh
        let tintColor = UIColor(.blue)
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: attributes)
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(TraderListViewController.pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupUI() {
        showProgressHUD()
        
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
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.refreshControl?.endRefreshing()
                self?.tableView?.reloadData()
            case .failure:
                break
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
        
        guard let programEntity = viewModel.getProgram(atIndex: indexPath.row)?.investmentProgramEntity else {
            return
        }

        viewModel.showProgramDetail(with: programEntity)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.getProgram(atIndex: indexPath.row) else {
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
        return viewModel.numberOfRowsIn(section: section)
    }
}


extension TraderListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let vc = viewModel.getProgramDetailViewController(withIndex: indexPath.row) else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}

extension TraderListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    //DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No data"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor(.darkGray)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Update"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor(.blue)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(.lightGray)
    }
    
    //DZNEmptyDataSetDelegate
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        showProgressHUD()
        pullToRefresh()
    }
}
