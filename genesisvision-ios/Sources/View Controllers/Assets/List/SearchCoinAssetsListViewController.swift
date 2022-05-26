//
//  SearchCoinAssetsViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 23.05.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class SearchCoinAssetsListViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModels: [CellViewAnyModel]? {
        didSet {
            reloadData()
        }
    }
    var filteredViewModels: [CellViewAnyModel]? {
        didSet {
            reloadData()
        }
    }
    var isFiltering = false {
        didSet {
            reloadData()
        }
    }
    var type: SearchCoinTabType?
    var delegate: SearchCoinAssetViewController?

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
        setupTableConfiguration()
    }

    private func setupUI() {
        bottomViewType = .none
        tableView.separatorStyle = .singleLine
    }

    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.configure(with: .defaultConfiguration)
        tableView.register(CoinAssetTableViewCell.self, forCellReuseIdentifier: CoinAssetTableViewCell.identifier)
        setupPullToRefresh(scrollView: tableView)
    }
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadDataSmoothly()
            switch self.isFiltering {
            case true:
                guard let count = self.filteredViewModels?.count else { return }
                self.tabmanBarItems?.forEach({ $0.badgeValue = "\(count)" })
            default:
                guard let count = self.viewModels?.count else { return }
                self.tabmanBarItems?.forEach({ $0.badgeValue = "\(count)" })
            }
        }
    }
    override func pullToRefresh() {
        super.pullToRefresh()
        fetch()
    }
    override func fetch() {
        CoinAssetsDataProvider.getAllCoinsList(completion: { coinAssetsViewModel in
            switch self.type {
            case .binance:
                self.viewModels = coinAssetsViewModel?.items?.filter({ $0.provider ==  .binance}).map({ item in
                    let viewModel = CoinAssetSearchTableViewCellViewModel(coinSearchItem: item)
                    let cell = CoinAssetTableViewCell(style: .default, reuseIdentifier: CoinAssetTableViewCell.identifier)
                    viewModel.setup(on: cell)
                    return viewModel
                })
            case .huobi:
                self.viewModels = coinAssetsViewModel?.items?.filter({ $0.provider ==  .huobi}).map({ item in
                    let viewModel = CoinAssetSearchTableViewCellViewModel(coinSearchItem: item)
                    let cell = CoinAssetTableViewCell(style: .default, reuseIdentifier: CoinAssetTableViewCell.identifier)
                    viewModel.setup(on: cell)
                    return viewModel
                })
            case .none:
                break
            }
        }, errorCompletion: { error in
        })
    }
    func filter(text: String) {
        filteredViewModels = self.viewModels?.filter({ viewModel in
            guard let vm = viewModel as? CoinAssetSearchTableViewCellViewModel,
                  let name = vm.coinSearchItem.name?.lowercased(),
                  let symbol = vm.coinSearchItem.asset?.lowercased()
            else { return false}
            return name.hasPrefix(text.lowercased()) || symbol.hasPrefix(text.lowercased())
        })
    }
}


extension SearchCoinAssetsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch isFiltering {
        case true:
            guard let model = filteredViewModels?[indexPath.row] as? CoinAssetSearchTableViewCellViewModel,
                  let symbol = model.coinSearchItem.asset else { return }
            delegate?.pushSelectedCoin(asset: symbol)
            
        default:
            guard let model = viewModels?[indexPath.row] as? CoinAssetSearchTableViewCellViewModel,
                  let symbol = model.coinSearchItem.asset else { return }
            delegate?.pushSelectedCoin(asset: symbol)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isFiltering {
        case true:
            guard let model = filteredViewModels?[indexPath.row] else { return TableViewCell() }
            return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        default:
            guard let model = viewModels?[indexPath.row] else { return TableViewCell() }
            return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isFiltering {
        case true:
            guard let itemsCount = filteredViewModels?.count else { return 0}
            return itemsCount
        default:
            guard let itemsCount = viewModels?.count else { return 0}
            return itemsCount
        }
    }
}
