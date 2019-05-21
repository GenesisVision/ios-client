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
    var dataSource: WalletPageboyViewControllerDataSource!
    var wallet: WalletData?
    var multiWallet: WalletMultiSummary?
    
    // MARK: - Init
    init(withRouter router: Router, wallet: WalletData? = nil, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        self.wallet = wallet
        
        font = UIFont.getFont(.semibold, size: 16)
        
        guard let wallet = wallet else {
            title = "Wallets"

            items = [TabmanBar.Item(title: "Balance"),
                     TabmanBar.Item(title: "My Wallets"),
                     TabmanBar.Item(title: "Copytrading accounts"),
                     TabmanBar.Item(title: "Transactions"),
                     TabmanBar.Item(title: "Deposits/Withdrawals")]
            
            dataSource = WalletPageboyViewControllerDataSource(router: router)
            
            return
        }
        
        if let currencyValue = wallet.currency?.rawValue {
            title = currencyValue
        }
        
        items = [TabmanBar.Item(title: "Balance"),
                 TabmanBar.Item(title: "Transactions"),
                 TabmanBar.Item(title: "Deposits/Withdrawals")]
        
        dataSource = WalletPageboyViewControllerDataSource(router: router, wallet: wallet)
    }
    
    // MARK: - Public methods
    func reloadDetails() {
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
    var wallet: WalletMultiSummary?
    
    // MARK: - Private methods
    internal override func setup(router: Router, wallet: WalletData? = nil) {
        if let router = router as? WalletRouter {
            if let vc = router.getBalance(wallet) {
                controllers.append(vc)
            }
            
            if wallet == nil, let vc = router.getWallets(wallet) {
                controllers.append(vc)
            }
            
            if wallet == nil, let vc = router.getCopytradingAccounts(wallet) {
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
