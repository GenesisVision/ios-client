//
//  InvestingEventsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingEventsViewModel: CellViewModelWithCollection {
    var router: Router?
    
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventCollectionViewCellViewModel.self]
    }
    
    var details: DashboardInvestingDetails?
    weak var delegate: BaseTableViewProtocol?
    init(_ details: DashboardInvestingDetails?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Events"
        type = .investingEvents
        
        details?.events?.items?.forEach({ (model) in
            viewModels.append(PortfolioEventCollectionViewCellViewModel(reloadDataProtocol: nil, event: model))
        })
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension InvestingEventsViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func getTotalCount() -> Int? {
        return details?.events?.total
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 170.0
    }
}



