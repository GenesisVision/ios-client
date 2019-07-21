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
    var accounts: [CopyTradingAccountInfo]?
    var account: CopyTradingAccountInfo?
    var multiWallet: WalletMultiSummary?
    
    var walletType: WalletType = .all
    // MARK: - Init
    init(withRouter router: Router, wallet: WalletData? = nil, account: CopyTradingAccountInfo? = nil, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil, walletType: WalletType) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
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
            
            items = [TabmanBar.Item(title: "Balance"),
                     TabmanBar.Item(title: "Transactions"),
                     TabmanBar.Item(title: "Deposits/Withdrawals")]
            
            dataSource = WalletPageboyViewControllerDataSource(router: router, wallet: wallet)
        case .account:
            guard let account = account else { return }
            
            if let title = account.title {
                self.title = title
            }
            
            items = [TabmanBar.Item(title: "Balance"),
                     TabmanBar.Item(title: "Open trades"),
                     TabmanBar.Item(title: "Trades history"),
                     TabmanBar.Item(title: "Trading log")]
            
            dataSource = WalletCopytradingPageboyViewControllerDataSource(router: router, account: account)
        case .all:
            self.title = "Wallets"

            items = [TabmanBar.Item(title: "Balance"), TabmanBar.Item(title: "My Wallets")]

            if signalEnable {
                items?.append(TabmanBar.Item(title: "Copytrading accounts"))
            }
    
            items?.append(contentsOf: [TabmanBar.Item(title: "Transactions"),
                                       TabmanBar.Item(title: "Deposits/Withdrawals")])
            
            dataSource = WalletPageboyViewControllerDataSource(router: router, wallet: nil)
        }
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        //TODO: 
        let controllers = dataSource.controllers
        if walletType == .account, let walletBalanceViewController = controllers[0] as? WalletBalanceViewController {
            walletBalanceViewController.viewModel.fetch()
        } else if let walletBalanceViewController = controllers[0] as? WalletBalanceViewController, let walletListViewController = controllers[1] as? WalletListViewController {
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
            
            if signalEnable, wallet == nil, let vc = router.getCopytradingAccounts(wallet) {
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

class WalletCopytradingPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    var copyTradingAccountInfo: CopyTradingAccountInfo?
    
    // MARK: - Private methods
    internal override func setup(router: Router, account: CopyTradingAccountInfo? = nil) {
        if let router = router as? WalletRouter {
            if let vc = router.getBalance(account: account) {
                controllers.append(vc)
            }
            
            let signalOpenTrades = router.getSignalOpenTrades(with: router, currency: CurrencyType(rawValue: account?.currency?.rawValue ?? ""))
            controllers.append(signalOpenTrades)
            
            let signalTrades = router.getSignalTrades(with: router, currency: CurrencyType(rawValue: account?.currency?.rawValue ?? ""))
            controllers.append(signalTrades)
            
            let signalTradingLog = router.getSignalTradingLog(with: router)
            controllers.append(signalTradingLog)
        }
    }
}
