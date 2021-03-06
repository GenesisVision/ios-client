//
//  InvestingRequestsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingRequestsViewModel: CellViewModelWithCollection {
    var router: Router?
    
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = false
    var details: AssetInvestmentRequestItemsViewModel?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return []
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: AssetInvestmentRequestItemsViewModel?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Requests"
        type = .investingRequests
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
}
    
extension InvestingRequestsViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setImage(#imageLiteral(resourceName: "img_arrow_right_icon"), for: .normal)
        showAllButton.tintColor = UIColor.primary
        showAllButton.isUserInteractionEnabled = false
        return [showAllButton]
    }
    
    func getTotalCount() -> Int? {
        return details?.items?.count
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 0
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
}


