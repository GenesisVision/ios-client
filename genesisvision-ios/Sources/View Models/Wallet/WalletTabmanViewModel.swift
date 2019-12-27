//
//  WalletTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UIColor
import Tabman

final class WalletTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var dataSource: BasePageboyViewControllerDataSource!
    var wallet: WalletData?
    var accounts: [TradingAccountDetails]?
    var account: TradingAccountDetails?
    var multiWallet: WalletSummary?
    
    var walletType: WalletType = .all
    
    // MARK: - Init
    init(withRouter router: Router, wallet: WalletData? = nil, account: TradingAccountDetails? = nil, walletType: WalletType) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.wallet = wallet
        self.account = account
        self.walletType = walletType
        
        font = UIFont.getFont(.semibold, size: 16)
        
        switch walletType {
        case .wallet:
            guard let wallet = wallet else { return }
            
            if let title = wallet.title {
                self.title = title
            }
            
            items = [TMBarItem(title: "Balance"),
                     TMBarItem(title: "Transactions"),
                     TMBarItem(title: "Deposits/Withdrawals")]
        case .all:
            self.title = "Wallets"

            items = [TMBarItem(title: "Balance"),
                     TMBarItem(title: "My Wallets"),
                     TMBarItem(title: "Transactions"),
                     TMBarItem(title: "Deposits/Withdrawals")]
        }
    }
    
    func getDataSources() -> BasePageboyViewControllerDataSource {
        switch walletType {
        case .wallet:
            dataSource = WalletPageboyViewControllerDataSource(router: router, wallet: wallet)
        case .all:
            dataSource = WalletPageboyViewControllerDataSource(router: router, wallet: nil)
        }
        
        return dataSource
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        //TODO: 
        let controllers = dataSource.controllers
        if let walletBalanceViewController = controllers[0] as? WalletBalanceViewController, let walletListViewController = controllers[1] as? WalletListViewController {
            walletBalanceViewController.viewModel.fetch()
            walletListViewController.viewModel.fetch()
        }
    }
    
    func showAboutFees() {
        router.showAboutFees()
    }
}

class WalletPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    var wallet: WalletSummary?
    
    // MARK: - Private methods
    internal override func setup(router: Router, wallet: WalletData? = nil) {
        if let router = router as? WalletRouter {
            if let vc = router.getBalance(wallet) {
                controllers.append(vc)
            }
            
            if wallet == nil, let vc = router.getWallets(wallet) {
                controllers.append(vc)
            }
            
            if let vc = router.getInternalTransactions(wallet) {
                controllers.append(vc)
            }
            
            if let vc = router.getExternalTransactions(wallet) {
                controllers.append(vc)
            }
        }
    }
}
