//
//  InvestingEventListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingEventListViewController: ListViewController {
    typealias ViewModel = InvestingEventListViewModel
    
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

extension InvestingEventListViewController: BaseCellProtocol {
}


class InvestingEventListViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventTableViewCellViewModel.self]
    }
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        let viewModel = PortfolioEventTableViewCellViewModel(event: InvestmentEventViewModel(title: "title", icon: nil, date: Date(), assetDetails: AssetDetails(id: nil, logo: nil, color: nil, title: "Asset", url: nil, assetType: .programs), amount: 20.0, currency: .btc, changeState: .increased, extendedInfo: nil, feesInfo: nil, totalFeesAmount: nil, totalFeesCurrency: nil))
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        
        delegate?.didReload()
    }
}
