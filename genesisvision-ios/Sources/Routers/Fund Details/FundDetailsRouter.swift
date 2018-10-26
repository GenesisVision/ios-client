//
//  FundDetailsRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class FundDetailsRouter: TabmanRouter {
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
    
    
    func getEvents(with fundId: String) -> BaseViewController? {
        return nil
    }
    
    func getBalance(with fundId: String) -> FundBalanceViewController? {
        guard let vc = currentController as? FundDetailsTabmanViewController else { return nil }
        
        let viewController = FundBalanceViewController()
        let router = Router(parentRouter: self)
        router.currentController = viewController
        let viewModel = FundBalanceViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with fundId: String) -> FundProfitViewController? {
        guard let vc = currentController as? FundDetailsTabmanViewController else { return nil }
        
        let viewController = FundProfitViewController()
        let router = Router(parentRouter: self)
        router.currentController = viewController
        let viewModel = FundProfitViewModel(withRouter: router, fundId: fundId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
