//
//  AccountRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class AccountRouter: TabmanRouter {
    // MARK: - Variables
    var accountViewController: AccountViewController?
    var accountInfoViewController: AccountInfoViewController?
    var accountBalanceViewController: BalanceViewController?
    var accountProfitViewController: ProfitViewController?
    var tradeListViewController: TradesViewController?
    var openTradeListViewController: TradesViewController?
    
    // MARK: - Public methods
    func getInfo(with assetId: String) -> AccountInfoViewController? {
        let viewController = AccountInfoViewController()
        
        let router = AccountInfoRouter(parentRouter: self)
        router.accountViewController = accountViewController
        router.currentController = viewController
        let viewModel = AccountInfoViewModel(withRouter: router, assetId: assetId, delegate: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        accountInfoViewController = viewController
        return viewController
    }
    
    func getTrades(with assetId: String, currencyType: CurrencyType) -> TradesViewController? {

        let viewController = TradesViewController()
        let viewModel = AccountTradesViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, currencyType: currencyType)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTradesOpen(with assetId: String, currencyType: CurrencyType) -> TradesViewController? {

        let viewController = TradesViewController()
        let viewModel = AccountTradesViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, isOpenTrades: true, currencyType: currencyType)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
