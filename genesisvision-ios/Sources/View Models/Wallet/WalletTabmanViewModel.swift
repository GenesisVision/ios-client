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
    enum TabType: String {
        case balance = "Balance"
        case myWallets = "My Wallets"
        case transactions = "Transactions"
        case externalTransactions = "Deposits/Withdrawals"
    }
    var tabTypes: [TabType] = []
    var controllers = [TabType : UIViewController]()
    
    // MARK: - Variables
    var wallet: WalletData?
    var accounts: [TradingAccountDetails]?
    var multiWallet: WalletSummary?
    
    var walletType: WalletType = .all
    
    // MARK: - Init
    init(withRouter router: Router, wallet: WalletData? = nil, walletType: WalletType) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.wallet = wallet
        self.walletType = walletType
        
        font = UIFont.getFont(.semibold, size: 16)
        
        switch walletType {
        case .wallet:
            guard let wallet = wallet else { return }
            
            if let title = wallet.title {
                self.title = title
            }
            tabTypes = [.balance, .transactions, .externalTransactions]
        case .all:
            self.title = "Wallets"
            tabTypes = [.balance, .myWallets, .transactions, .externalTransactions]
        }
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        if let balanceVC = getViewController(.balance) as? WalletBalanceViewController {
            balanceVC.viewModel.fetch()
        }
        if let myWalletsVC = getViewController(.myWallets) as? WalletListViewController {
            myWalletsVC.viewModel.fetch()
        }
    }
    func getViewController(_ type: TabType) -> UIViewController? {
        guard let router = router as? WalletRouter else { return nil }
        
        switch type {
        case .balance:
            return controllers[type] ?? router.getBalance(wallet)
        case .myWallets:
            return controllers[type] ?? router.getWallets(wallet)
        case .transactions:
            return controllers[type] ?? router.getInternalTransactions(wallet)
        case .externalTransactions:
            return controllers[type] ?? router.getExternalTransactions(wallet)
        }
    }
    func showAboutFees() {
        router.showAboutFees()
    }
}

extension WalletTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index])
    }
}
