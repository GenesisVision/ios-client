//
//  ProgramRequestsViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import ViewAnimator

class ProgramRequestsViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: ProgramRequestsViewModel!
    
    // MARK: - Variables
    private let tableViewAnimation = AnimationType.from(direction: .right, offset: 30.0)
    
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
    
    // MARK: - Private methods
    private func setup() {
        showProgressHUD()
        fetch()
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: ProgramRequestsViewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.animateViews(animations: [tableViewAnimation])
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
    
    private func fetch() {
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
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension ProgramRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
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

extension ProgramRequestsViewController: ProgramRequestTableViewCellProtocol {
    func cancelRequestDidPress(with requestID: String) {
        showProgressHUD()
        viewModel.cancel(with: requestID) { [weak self]  (result) in
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { (success) in
                    self?.fetch()
                })
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
            }
        }
    }
}
