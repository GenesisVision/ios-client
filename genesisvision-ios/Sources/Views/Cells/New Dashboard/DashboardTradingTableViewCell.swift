//
//  DashboardTradingTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 15.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DashboardTradingCellViewModel<ViewModelType: ViewModelWithCollection> {
    var viewModel: ViewModelType
    var dataSource: CollectionViewDataSource<ViewModelType>!
    let data: TradingHeaderData
    weak var delegate: BaseCellProtocol?
    init(_ viewModel: ViewModelType, data: TradingHeaderData, delegate: BaseCellProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.data = data
        
        dataSource = CollectionViewDataSource(viewModel)
    }
}

extension DashboardTradingCellViewModel: CellViewModel {
    func setup(on cell: DashboardTradingTableViewCell) {
        cell.configure(viewModel, delegate: delegate, collectionViewDelegate: dataSource, collectionViewDataSource: dataSource, cellModelsForRegistration: viewModel.cellModelsForRegistration)
        cell.labelsView.configure(data)
    }
}

class DashboardTradingTableViewCell: CellWithCollectionView {
    @IBOutlet weak var labelsView: DashboardTradingLabelsView!
}
class TradingCollectionViewModel: ViewModelWithCollection {
    var title: String
    var showActionsView: Bool
    var type: CellActionType

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventCollectionViewCellViewModel.self]
    }

    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
        self.title = "Trading"
        self.showActionsView = true
        self.type = .dashboardTrading
        
        let viewModel = PortfolioEventCollectionViewCellViewModel(reloadDataProtocol: nil, event: InvestmentEventViewModel(title: "title", icon: nil, date: Date(), assetDetails: AssetDetails(id: nil, logo: nil, color: nil, title: "Asset", url: nil, assetType: .programs), amount: 20.0, currency: .btc, changeState: .increased, extendedInfo: nil, feesInfo: nil, totalFeesAmount: nil, totalFeesCurrency: nil))
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(at: indexPath))
    }
    
    func getActions() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }

    @IBAction func addButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .add)
    }
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}
