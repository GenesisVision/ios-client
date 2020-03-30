//
//  InvestingProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class BaseListViewController<ViewModel: ListViewModelWithPaging>: ListViewController {
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
    
    func show(_ model: Codable) {
        
    }
}

class InvestingProgramListViewController: ListViewController {
    typealias ViewModel = InvestingProgramListViewModel
    
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
    
    func show(_ model: ProgramInvestingDetailsList) {
        if let router = viewModel.router, let uuiString = model.id?.uuidString {
            router.showAssetDetails(with: uuiString, assetType: .program)
       }
    }
}

extension InvestingProgramListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .investingPrograms:
            if let cellViewModel = cellViewModel as? ProgramInvestingTableViewCellViewModel {
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

class InvestingProgramListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramInvestingTableViewCellViewModel.self]
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
        var models = [ProgramInvestingTableViewCellViewModel]()
        DashboardDataProvider.getInvestingPrograms(currency: currency, status: .all, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                //FIXIT: Add filterProtocol, favoriteProtocol
                let viewModel = ProgramInvestingTableViewCellViewModel(asset: asset, filterProtocol: nil, favoriteProtocol: nil)
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
        delegate?.didSelect(.investingPrograms, cellViewModel: model(for: indexPath))
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    
}

