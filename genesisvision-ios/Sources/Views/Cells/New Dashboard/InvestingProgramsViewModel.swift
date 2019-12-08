//
//  InvestingProgramsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingProgramsViewModel: ViewModelWithCollection {
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
        title = "Programs"
        showActionsView = true
        type = .investingPrograms
        
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
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension InvestingProgramsViewModel {
    func getActions() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func makeLayout() -> UICollectionViewLayout {
        var layout: UICollectionViewLayout!
        if #available(iOS 13.0, *) {
            layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                let itemInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: Constants.SystemSizes.Cell.horizontalMarginValue, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: Constants.SystemSizes.Cell.horizontalMarginValue)
                let sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: 0.0)
                
                item.contentInsets = itemInset
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = sectionInset
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        } else {
            // Fallback on earlier versions
        }
        return layout
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return viewModels.count > 2 ? 300.0 : 150.0
    }
}
