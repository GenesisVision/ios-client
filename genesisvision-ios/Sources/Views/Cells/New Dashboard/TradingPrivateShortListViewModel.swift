//
//  TradingPrivateShortListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPrivateShortListViewModel: ViewModelWithCollection {
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
        title = "Private"
        showActionsView = true
        type = .tradingPrivateList
        
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

    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}


