//
//  AssetInvestingPortfolioListViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class AssetInvestingPortfolioListViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModel: InvestingAssetPortfolioViewModel!
    
    // MARK: - Outlets
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarDidScrollToTop(_:)), name: .tabBarDidScrollToTop, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }

        bottomViewType = .none
    }
    
    private func setupTableConfiguration() {
        
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.register(CoinAssetTableViewCell.self, forCellReuseIdentifier: CoinAssetTableViewCell.identifier)
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()

        viewModel.refresh { (result) in }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadDataSmoothly()
        }
    }
    override func fetch() {
//        showProgressHUD()
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            if let totalCount = self?.viewModel.totalCount {
                self?.tabmanBarItems?.forEach({ $0.badgeValue = "\(totalCount)" })
            }
        }
    }
}

extension AssetInvestingPortfolioListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.numberOfRows(in: indexPath.section) >= indexPath.row else { return }

        if let model = viewModel.model(for: indexPath) as? CoinAssetPortfolioTableViewCellViewModel {
            guard let id = model.coinAsset.asset else { return }
            viewModel.showAssetDetails(with: id, assetType: .coinAsset)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let model = viewModel.model(for: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.rowHeight(for: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}

extension AssetInvestingPortfolioListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}
