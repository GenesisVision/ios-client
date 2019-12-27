//
//  InvestingRequestsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingRequestsViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = true
    var details: ItemsViewModelAssetInvestmentRequest?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventCollectionViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: ItemsViewModelAssetInvestmentRequest?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Requests"
        type = .none
        
//        details?.events?.items?.forEach({ (model) in
//            viewModels.append(PortfolioEventCollectionViewCellViewModel(reloadDataProtocol: nil, event: model))
//        })
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(at: indexPath))
    }
    
    
}


