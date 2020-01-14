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
        self.title = "Recommendation"
        self.type = .dashboardRecommendation
        
        details?.programs?.items?.forEach({ (viewModel) in
            let asset = AssetDetailData()
            asset.program = viewModel
            viewModels.append(AssetCollectionViewCellViewModel(type: .program, asset: asset, delegate: nil))
        })
        details?.follows?.items?.forEach({ (viewModel) in
            let asset = AssetDetailData()
            asset.follow = viewModel
            viewModels.append(AssetCollectionViewCellViewModel(type: .follow, asset: asset, delegate: nil))
        })
        details?.funds?.items?.forEach({ (viewModel) in
            let asset = AssetDetailData()
            asset.fund = viewModel
            viewModels.append(AssetCollectionViewCellViewModel(type: .fund, asset: asset, delegate: nil))
        })
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
    
    func makeLayout() -> UICollectionViewLayout {
        return CustomLayout.defaultLayout(1)
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
