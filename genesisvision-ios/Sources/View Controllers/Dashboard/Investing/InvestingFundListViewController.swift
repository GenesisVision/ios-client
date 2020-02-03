//
//  InvestingFundListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingFundListViewController: ListViewController {
    typealias ViewModel = InvestingFundListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.refresh()
    }
    // MARK: - Methods
    private func setup() {
        tableView.configure(with: .defaultConfiguration)
        isEnableInfiniteIndicator = true
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
    }
    
    func show(_ model: FundInvestingDetailsList) {
        if let router = viewModel.router, let uuiString = model.id?.uuidString {
            router.showAssetDetails(with: uuiString, assetType: .fund)
       }
    }
}

extension InvestingFundListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .investingFunds:
            if let cellViewModel = cellViewModel as? FundInvestingTableViewCellViewModel {
                show(cellViewModel.asset)
            }
        default:
            break
        }
    }
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
}

class InvestingFundListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundInvestingTableViewCellViewModel.self]
    }
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    var router: Router?
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [FundInvestingTableViewCellViewModel]()
        DashboardDataProvider.getInvestingFunds(currency: currency, status: .all, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                //FIXIT: Add filterProtocol, favoriteProtocol
                let viewModel = FundInvestingTableViewCellViewModel(asset: asset, filterProtocol: nil, favoriteProtocol: nil)
                models.append(viewModel)
            })
            self?.updateViewModels(models, refresh: refresh, total: model.total)
            }, errorCompletion: errorCompletion)
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        skip += take()
        viewModels = refresh ? models : viewModels + models
        delegate?.didReload()
    }
    
    func cellAnimations() -> Bool {
        return true
    }
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.investingFunds, cellViewModel: model(for: indexPath))
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
}

