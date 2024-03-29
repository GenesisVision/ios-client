//
//  InvestingFundsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingFundsViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    var details: FundInvestingDetailsListItemsViewModel?
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: FundInvestingDetailsListItemsViewModel?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Funds"
        type = .investingFunds
        
        details?.items?.forEach({ (viewModel) in
            //FIXIT: Add filterProtocol, favoriteProtocol
            viewModels.append(AssetCollectionViewCellViewModel(type: .fund, asset: viewModel, filterProtocol: nil, favoriteProtocol: nil))
        })
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension InvestingFundsViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 250.0
    }
    
    func getTotalCount() -> Int? {
        return details?.total
    }
}
