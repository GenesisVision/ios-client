//
//  InvestingProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingProgramListViewController: ListViewController {
    typealias ViewModel = InvestingProgramListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
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
        viewModel = ViewModel(self)
        
        tableView.configure(with: .defaultConfiguration)
        isEnableInfiniteIndicator = true
        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension InvestingProgramListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
}

class InvestingProgramListViewModel: ListViewModelWithPaging {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
    }
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [ProgramInvestingTableViewCellViewModel]()
        DashboardDataProvider.getInvestingPrograms(currency: currency, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                let viewModel = ProgramInvestingTableViewCellViewModel(asset: asset, delegate: nil)
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
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    
}

