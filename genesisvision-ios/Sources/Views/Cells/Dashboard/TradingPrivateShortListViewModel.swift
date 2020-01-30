//
//  TradingPrivateShortListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPrivateShortListViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    var details: ItemsViewModelDashboardTradingAsset?
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ details: ItemsViewModelDashboardTradingAsset?, delegate: BaseTableViewProtocol?, router: Router?) {
        self.details = details
        self.router = router
        self.delegate = delegate
        title = "Private"
        type = .tradingPrivateList
        
        details?.items?.forEach({ (viewModel) in
            guard let assetType = viewModel.assetType else { return }
            viewModels.append(AssetCollectionViewCellViewModel(type: assetType, asset: viewModel, filterProtocol: nil, favoriteProtocol: nil))
        })
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .add)
    }
}

extension TradingPrivateShortListViewModel {
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
    
    func getLeftButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setImage(#imageLiteral(resourceName: "img_add_photo_icon"), for: .normal)
        showAllButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        guard let model = model(for: indexPath) as? AssetCollectionViewCellViewModel,
            let tradingAsset = model.asset as? DashboardTradingAsset,
            let assetType = tradingAsset.assetType,
            let actions = tradingAsset.actions else { return nil }
        
        var children = [UIAction]()
        
        if let name = tradingAsset.publicInfo?.url {
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                let url = getRoute(assetType, name: name)
                self?.router?.share(url)
            }
            children.append(share)
        }
        
        if let canMakeProgramFromPrivateTradingAccount = actions.canMakeProgramFromPrivateTradingAccount, canMakeProgramFromPrivateTradingAccount {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromPrivateTradingAccount = actions.canMakeSignalProviderFromPrivateTradingAccount, canMakeSignalProviderFromPrivateTradingAccount {
            let makeSignal = UIAction(title: "Make signal", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(makeSignal)
        }
        
        if let canChangePassword = actions.canChangePassword, canChangePassword {
            let changePassword = UIAction(title: "Change password", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(changePassword)
        }
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}


