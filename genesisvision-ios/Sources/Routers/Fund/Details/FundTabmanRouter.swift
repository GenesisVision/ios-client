//
//  FundTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class FundTabmanRouter: TabmanRouter {
    // MARK: - Variables
    var fundInfoViewController: FundInfoViewController?
    
    // MARK: - Public methods
    func getInfo(with fundDetailsFull: FundDetailsFull) -> FundInfoViewController? {
        let viewController = FundInfoViewController()
        
        let router = FundInfoRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = FundInfoViewModel(withRouter: router, fundDetailsFull: fundDetailsFull, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        fundInfoViewController = viewController
        return viewController
    }
    
    func getAssets(with fundId: String) -> FundAssetsViewController? {
        guard let router = self.parentRouter as? FundRouter else { return nil }
        
        let viewController = FundAssetsViewController()
        router.currentController = viewController
        let viewModel = FundAssetsViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getBalance(with fundId: String) -> FundBalanceViewController? {
        guard let router = self.parentRouter as? FundRouter else { return nil }
        
        let viewController = FundBalanceViewController()
        router.currentController = viewController
        let viewModel = FundBalanceViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with fundId: String) -> FundProfitViewController? {
        guard let router = self.parentRouter as? FundRouter else { return nil }
        
        let viewController = FundProfitViewController()
        router.currentController = viewController
        let viewModel = FundProfitViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with assetId: String) -> AllEventsViewController? {
        guard let router = self.parentRouter as? FundRouter, let viewController = getEventsViewController(with: assetId, router: router, allowsSelection: false) else { return nil }
        
        return viewController
    }
    
    func getReallocateHistory(with fundId: String) -> FundReallocateHistoryViewController? {
        guard let router = self.parentRouter as? FundRouter else { return nil }
        
        let viewController = FundReallocateHistoryViewController()
        router.currentController = viewController
        let viewModel = FundReallocateHistoryViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: viewController, delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
