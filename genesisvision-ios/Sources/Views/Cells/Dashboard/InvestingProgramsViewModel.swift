//
//  InvestingProgramsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingProgramsViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    var details: ProgramInvestingDetailsListItemsViewModel?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: ProgramInvestingDetailsListItemsViewModel?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        title = "Programs"
        type = .investingPrograms
        
        if let items = details?.items, items.isEmpty {
            viewModels.append(AssetCollectionViewCellViewModel(type: .program, asset: nil, filterProtocol: nil, favoriteProtocol: nil))
        } else {
            details?.items?.forEach({ (viewModel) in
                viewModels.append(AssetCollectionViewCellViewModel(type: .program, asset: viewModel, filterProtocol: nil, favoriteProtocol: nil))
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

extension InvestingProgramsViewModel {
    func getRightButtons() -> [UIButton] {
        guard let items = details?.items, !items.isEmpty else { return [UIButton()]}
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func getCollectionViewHeight() -> CGFloat {
        if let items = details?.items, items.isEmpty {
            return 150.0
        } else {
            return 250.0
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
            return CGSize(width: frame.width - 30, height: 250.0)
        }
    }
}
