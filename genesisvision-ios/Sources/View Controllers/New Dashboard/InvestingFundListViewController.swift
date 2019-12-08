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
    var dataSource: TableViewDataSource<ViewModel>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    
    // MARK: - Methods
    private func setup() {
        viewModel = ViewModel(self)
        
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension InvestingFundListViewController: BaseCellProtocol {
  
}

class InvestingFundListViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
    }
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        let viewModel = FundTableViewCellViewModel(asset: FundDetails(totalAssetsCount: 1, topFundAssets: [FundAssetPercent(asset: "title", name: "name", percent: 10, icon: nil)], statistic: nil, personalDetails: nil, dashboardAssetsDetails: nil, id: nil, logo: nil, url: nil, color: nil, title: "title", description: "Descr", status: .active, creationDate: Date(), manager: nil, chart: nil), delegate: nil)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        
        delegate?.didReload()
    }
}

