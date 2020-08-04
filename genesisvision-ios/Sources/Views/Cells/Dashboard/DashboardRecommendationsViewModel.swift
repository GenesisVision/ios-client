//
//  DashboardRecommendationsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardRecommendationsViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    var details: CommonPublicAssetsViewModel?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: CommonPublicAssetsViewModel?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        self.title = "Recommendations"
        self.type = .dashboardRecommendation
        
        guard let programs = details?.programs?.items, let funds = details?.funds?.items, let follows = details?.follows?.items else { return }
        
        var allCount = 0
        
        if programs.count == funds.count, funds.count == follows.count {
            allCount = programs.count
        } else {
            allCount = min(programs.count, funds.count, follows.count)
        }
                
        for index in 0...allCount-1 {
            if let program = programs[safe: index] {
                viewModels.append(AssetCollectionViewCellViewModel(type: .program, asset: program, filterProtocol: nil, favoriteProtocol: nil))
            }
            if let fund = funds[safe: index] {
                viewModels.append(AssetCollectionViewCellViewModel(type: .fund, asset: fund, filterProtocol: nil, favoriteProtocol: nil))
            }
            if let follow = follows[safe: index] {
                viewModels.append(AssetCollectionViewCellViewModel(type: .fund, asset: follow, filterProtocol: nil, favoriteProtocol: nil))
            }
        }
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    

    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension DashboardRecommendationsViewModel {
    func getRightButtons() -> [UIButton] {
        return []
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 250.0
    }
    
    func getTotalCount() -> Int? {
        var total = 0
        if let value = details?.follows?.total {
            total += value
        }
        if let value = details?.funds?.total {
            total += value
        }
        if let value = details?.programs?.total {
            total += value
        }
        return total
    }
    
    func didTapAddButtonAction() {
        delegate?.action(type, actionType: .add)
    }
}
