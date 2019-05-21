//
//  WalletRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletRouteType {
    case withdraw(currencyType: CurrencyType), deposit(currencyType: CurrencyType, walletMultiSummary: WalletMultiSummary?), programList, transfer(from: CurrencyType, to: CurrencyType, walletMultiSummary: WalletMultiSummary?), withdrawAccount(currencyType: CurrencyType, accounts: [CopyTradingAccountInfo]?, walletMultiSummary: WalletMultiSummary?), depositAccount(currencyType: CurrencyType, accounts: [CopyTradingAccountInfo]?, walletMultiSummary: WalletMultiSummary?)
    case showAssetDetails(assetId: String, assetType: AssetType)
}

class WalletRouter: Router {
    
    var walletBalanceViewController: WalletBalanceViewController?
    var walletTabmanViewController: WalletViewController?
    
    // MARK: - Public methods
    func show(routeType: WalletRouteType) {
        switch routeType {
        case .withdraw(let currencyType):
            withdraw(currencyType)
        case .deposit(let currencyType, let walletMultiSummary):
            deposit(currencyType, walletMultiSummary: walletMultiSummary)
        case .transfer(let from, let to, let walletMultiSummary):
            transfer(from: from, to: to, walletMultiSummary: walletMultiSummary)
        case .showAssetDetails(let assetId, let assetType):
            showAssetDetails(with: assetId, assetType: assetType)
        case .programList:
            showProgramList()
        case .withdrawAccount(let currencyType, let accounts, let walletMultiSummary):
            withdrawAccount(currencyType, accounts: accounts, walletMultiSummary: walletMultiSummary)
        case .depositAccount(let currencyType, let accounts, let walletMultiSummary):
            depositAccount(currencyType, accounts: accounts, walletMultiSummary: walletMultiSummary)
        }
    }
    
    func getBalance(_ wallet: WalletData? = nil) -> WalletBalanceViewController? {
        guard let viewController = WalletBalanceViewController.storyboardInstance(.wallet) else { return nil }
        let viewModel = WalletBalanceViewModel(withRouter: self, reloadDataProtocol: viewController, wallet: wallet)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getWallets(_ wallet: WalletData? = nil) -> WalletListViewController? {
        guard wallet == nil, let viewController = WalletListViewController.storyboardInstance(.wallet) else { return nil }
        
        let viewModel = WalletListViewModel(withRouter: self, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getCopytradingAccounts(_ wallet: WalletData? = nil) -> WalletCopytradingAccountListViewController? {
        guard wallet == nil, let viewController = WalletCopytradingAccountListViewController.storyboardInstance(.wallet) else { return nil }
        
        let viewModel = WalletCopytradingAccountListViewModel(withRouter: self, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getInternalTransactions(_ wallet: WalletData? = nil) -> WalletTransactionListViewController? {
        let viewController = WalletTransactionListViewController()
        let viewModel = WalletInternalTransactionListViewModel(withRouter: self, reloadDataProtocol: viewController, wallet: wallet)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getExternalTransactions(_ wallet: WalletData? = nil) -> WalletTransactionListViewController? {
        let viewController = WalletTransactionListViewController()
        let viewModel = WalletExternalTransactionListViewModel(withRouter: self, reloadDataProtocol: viewController, wallet: wallet)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .assetList)
    }
    
    private func withdraw(_ currency: CurrencyType) {
        guard let vc = topViewController() as? WalletProtocol else { return }
        
        guard let viewController = WalletWithdrawViewController.storyboardInstance(.wallet) else { return }
        let router = WalletWithdrawRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = WalletWithdrawViewModel(withRouter: router, walletProtocol: vc, currency: currency)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func deposit(_ currency: CurrencyType, walletMultiSummary: WalletMultiSummary?) {
        guard let viewController = WalletDepositViewController.storyboardInstance(.wallet) else { return }
        let router = WalletDepositRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = WalletDepositViewModel(withRouter: router, currency: currency, walletMultiSummary: walletMultiSummary)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func transfer(from: CurrencyType, to: CurrencyType, walletMultiSummary: WalletMultiSummary?) {
        guard let walletMultiSummary = walletMultiSummary, let vc = topViewController() as? WalletProtocol else { return }
        
        guard let viewController = WalletTransferViewController.storyboardInstance(.wallet) else { return }
        let viewModel = WalletTransferViewModel(withRouter: self, walletProtocol: vc, walletMultiSummary: walletMultiSummary)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func withdrawAccount(_ currency: CurrencyType, accounts: [CopyTradingAccountInfo]?, walletMultiSummary: WalletMultiSummary?) {
        transferAccounts(currency: currency, accounts: accounts, walletMultiSummary: walletMultiSummary, walletToAccount: false)
    }
    
    private func depositAccount(_ currency: CurrencyType, accounts: [CopyTradingAccountInfo]?, walletMultiSummary: WalletMultiSummary?) {
        transferAccounts(currency: currency, accounts: accounts, walletMultiSummary: walletMultiSummary, walletToAccount: true)
    }
    
    private func transferAccounts(currency: CurrencyType, accounts: [CopyTradingAccountInfo]?, walletMultiSummary: WalletMultiSummary?, walletToAccount: Bool) {
        guard let accounts = accounts, let wallets = walletMultiSummary?.wallets, let vc = topViewController() as? WalletProtocol else { return }
        
        guard let viewController = WalletAccountsTransferViewController.storyboardInstance(.wallet) else { return }
        let viewModel = WalletAccountsTransferViewModel(withRouter: self, walletProtocol: vc, accounts: accounts, wallets: wallets, walletToAccount: walletToAccount, currency: currency)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
