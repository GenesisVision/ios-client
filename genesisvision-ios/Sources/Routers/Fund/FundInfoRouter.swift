//
//  FundInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum FundInfoRouteType {
    case invest(assetId: String)
    case withdraw(assetId: String)
    case manager(managerId: String)
    case manageAssets(assetId: String)
    case editPublicInfo(assetId: String)
}

class FundInfoRouter: Router {
    // MARK: - Public methods
    func show(routeType: FundInfoRouteType) {
        switch routeType {
        case .invest(let assetId):
            invest(with: assetId)
        case .withdraw(let assetId):
            withdraw(with: assetId)
        case .manager(let managerId):
            showAssetDetails(with: managerId, assetType: ._none)
        case .manageAssets(let assetId):
            manageAssets(with: assetId)
        case .editPublicInfo(assetId: let assetId):
            editPublicInfo(with: assetId)
        }
    }
    
    // MARK: - Private methods
    private func invest(with assetId: String) {
        guard let fundViewController = parentRouter?.topViewController() as? FundViewController,
            let viewController = FundInvestViewController.storyboardInstance(.fund) else { return }
        
        let router = FundInvestRouter(parentRouter: self)
        let viewModel = FundInvestViewModel(withRouter: router, assetId: assetId, detailProtocol: fundViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func withdraw(with assetId: String) {
        guard let fundViewController = parentRouter?.topViewController() as? FundViewController,
            let viewController = FundWithdrawViewController.storyboardInstance(.fund) else { return }
        
        let router = FundWithdrawRouter(parentRouter: self)
        let viewModel = FundWithdrawViewModel(withRouter: router, assetId: assetId, detailProtocol: fundViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func manageAssets(with assetId: String) {
        guard let viewController = FundManageViewController.storyboardInstance(.fund) else { return }
        
        let viewModel = ManageFundViewModel(with: assetId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func editPublicInfo(with assetId: String) {
        guard let viewController = FundPublicInfoViewController.storyboardInstance(.fund) else { return }
        let viewModel = FundPublicInfoViewModel(mode: .edit, assetId: assetId)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

