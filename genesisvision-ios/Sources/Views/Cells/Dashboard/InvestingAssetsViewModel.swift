//
//  InvestingAssetsViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 14.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//
import UIKit

class InvestingAssetsViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = true
    var details: CoinsAssetItemsViewModel?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    weak var delegate: BaseTableViewProtocol?
    
    init(_ details: CoinsAssetItemsViewModel?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Assets"
        type = .investingAssets
        
        if let items = details?.items, items.isEmpty {
            viewModels.append(AssetCollectionViewCellViewModel(type: .coinAsset, asset: nil, filterProtocol: nil, favoriteProtocol: nil))
        } else {
            details?.items?.forEach({ (viewModel) in
                guard viewModels.count < Constants.CoinAssetsConstants.maxValueOfCoinAssetsInInvestingVC else { return }
                viewModels.append(AssetCollectionViewCellViewModel(type: ._none, asset: viewModel, filterProtocol: nil, favoriteProtocol: nil))
            })
        }
    }
    
    func didSelect(at indexPath: IndexPath) {
        guard let items = details?.items, !items.isEmpty else { return }
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension InvestingAssetsViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func getCollectionViewHeight() -> CGFloat {
        if viewModels.isEmpty {
            return 150.0
        } else {
            return CGFloat(viewModels.count * 100)
        }
    }
    
    func getTotalCount() -> Int? {
        if let items = details?.items, items.isEmpty {
            return 1
        } else {
            return details?.total
        }
    }
    
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        if let items = details?.items, items.isEmpty {
            return CGSize(width: frame.width - 30, height: 100.0)
        } else {
            return CGSize(width: frame.width - 20, height: 80)
        }
    }
}
