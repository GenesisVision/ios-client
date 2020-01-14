//
//  FundRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

class FundRouter: TabmanRouter {
    // MARK: - Variables
    var fundViewController: FundViewController?
    var fundInfoViewController: FundInfoViewController?
    var fundBalanceViewController: BalanceViewController?
    var fundProfitViewController: ProfitViewController?
    
    // MARK: - Public methods
    func getInfo(with assetId: String) -> FundInfoViewController? {
        let viewController = FundInfoViewController()
        
        let router = FundInfoRouter(parentRouter: self)
        router.fundsViewController = fundsViewController
        router.currentController = viewController
        let viewModel = FundInfoViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        fundInfoViewController = viewController
        return viewController
    }
    
    func getAssets() -> FundAssetsViewController? {
        let viewController = FundAssetsViewController()
        let viewModel = FundAssetsViewModel(withRouter: self, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with assetId: String) -> EventListViewController? {
        guard let viewController = getEventsViewController(with: assetId, router: self, allowsSelection: false, assetType: .fund) else { return nil }
        
        return viewController
    }
    
    func getReallocateHistory(with assetId: String) -> FundReallocateHistoryViewController? {

        let viewController = FundReallocateHistoryViewController()
        let viewModel = FundReallocateHistoryViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
