//
//  TradingPublicShortListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPublicShortListViewModel: CellViewModelWithCollection {
    var type: CellActionType
    var canPullToRefresh: Bool = false
    var title: String
    
    var viewModels = [CellViewAnyModel]()
    var details: ItemsViewModelDashboardTradingAsset?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ details: ItemsViewModelDashboardTradingAsset?, delegate: BaseTableViewProtocol?, router: Router?) {
        self.delegate = delegate
        self.router = router
        self.details = details
        title = "Public"
        type = .tradingPublicList
        
        details?.items?.forEach({ (viewModel) in
            guard let assetType = viewModel.assetType else { return }
            let asset = AssetDetailData()
            asset.tradingAsset = viewModel
            viewModels.append(AssetCollectionViewCellViewModel(type: assetType, asset: asset, delegate: nil))
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

extension TradingPublicShortListViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("show all", for: .normal)
        showAllButton.setTitleColor(.primary, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
    
    func makeLayout() -> UICollectionViewLayout {
        return CustomLayout.defaultLayout(1, pagging: false)
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 300.0
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
        let tradingAsset = model.asset.tradingAsset,
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
        
        if let assetType = tradingAsset.assetType, assetType == .program {
            let closePriod = UIAction(title: "Close period", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(closePriod)
        }
        
        if let canMakeProgramFromSignalProvider = actions.canMakeProgramFromSignalProvider, canMakeProgramFromSignalProvider {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromProgram = actions.canMakeSignalProviderFromProgram, canMakeSignalProviderFromProgram {
            let makeSignal = UIAction(title: "Make a signal provider", image: nil) { [weak self] action in
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
        
        let settings = UIAction(title: "Settings", image: nil) { [weak self] action in
            //TODO: Make signal action
        }
        children.append(settings)
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}
