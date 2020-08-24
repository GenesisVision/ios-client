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
    case edit(assetId: String)
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
        case .edit(let assetId):
            edit(with: assetId)
        }
    }
    
    // MARK: - Private methods
    func invest(with assetId: String) {
        guard let fundViewController = parentRouter?.topViewController() as? FundViewController,
            let viewController = FundInvestViewController.storyboardInstance(.fund) else { return }
        
        let router = FundInvestRouter(parentRouter: self)
        let viewModel = FundInvestViewModel(withRouter: router, assetId: assetId, detailProtocol: fundViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with assetId: String) {
        guard let fundViewController = parentRouter?.topViewController() as? FundViewController,
            let viewController = FundWithdrawViewController.storyboardInstance(.fund) else { return }
        
        let router = FundWithdrawRouter(parentRouter: self)
        let viewModel = FundWithdrawViewModel(withRouter: router, assetId: assetId, detailProtocol: fundViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func edit(with assetId: String) {
        guard let viewController = ManageFundViewController.storyboardInstance(.fund) else { return }
        
        let viewModel = ManageFundViewModel(with: assetId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

