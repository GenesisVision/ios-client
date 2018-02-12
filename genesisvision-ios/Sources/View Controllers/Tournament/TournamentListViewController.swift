//
//  TournamentListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TournamentListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var canFetchMoreResults = true
    private var refreshControl: UIRefreshControl!
    
    // MARK: - View Model
    var viewModel: TournamentListViewModel! {
        didSet {
            pullToRefresh()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
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
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNibs(for: TournamentListViewModel.cellModelsForRegistration)
        
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
    }
    
    
    private func fetchMore() {
        self.canFetchMoreResults = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure:
                break
            }
        }
    }
    
    @objc private func pullToRefresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}


extension TournamentListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        
        guard let vc = viewModel.getDetailViewController(with: indexPath.row) else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}

extension TournamentListViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        showProgressHUD()
        pullToRefresh()
    }
}

