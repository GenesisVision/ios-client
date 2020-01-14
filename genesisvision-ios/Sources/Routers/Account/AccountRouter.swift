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
    var tradeListViewController: ProgramTradesViewController? //FIXIT:
    var openTradeListViewController: ProgramTradesViewController? //FIXIT:
    
    // MARK: - Public methods
    func getInfo(with assetId: String) -> AccountInfoViewController? {
        let viewController = AccountInfoViewController()
        
        let router = AccountInfoRouter(parentRouter: self)
        router.accountViewController = accountViewController
        router.currentController = viewController
        let viewModel = AccountInfoViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        accountInfoViewController = viewController
        return viewController
    }
    
    func getTrades(with assetId: String, currencyType: CurrencyType) -> AccountListViewController? {
        return nil
        //FIXIT:
//        let viewController = AccountListViewController()
//        let viewModel = AccountTradeListViewModel(self, assetId: assetId, isOpenTrades: false, currency: currencyType, delegate: viewController)
//        viewController.viewModel = viewModel
//        tradeListViewController = viewController
//        return viewController
    }
    
    func getTradesOpen(with assetId: String, currencyType: CurrencyType) -> AccountListViewController? {
        return nil
        //FIXIT:
//        let viewController = AccountListViewController()
//        let viewModel = AccountTradeListViewModel(self, assetId: assetId, isOpenTrades: true, currency: currencyType, delegate: viewController)
//        viewController.viewModel = viewModel
//        openTradeListViewController = viewController
//        return viewController
    }
}
