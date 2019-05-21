//
//  WalletAccountsTransferViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

final class WalletAccountsTransferViewModel {
    // MARK: - Variables
    var title: String = "Transfer"
    var disclaimer = "The funds will be converted according to the current market price (via market order on Binance)."
    var labelPlaceholder: String = "0"
    
    private weak var walletProtocol: WalletProtocol?
    
    var accounts: [CopyTradingAccountInfo]?
    var wallets: [WalletData]?
    
    var selectedCurrency: CopyTradingAccountInfo.Currency?

    var selectedAccountDelegateManager: AccountsDepositCurrencyDelegateManager?
    var selectedWalletDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    var walletToAccount: Bool = true
    
    private var router: WalletRouter!
    
    // MARK: - Init
    init(withRouter router: WalletRouter, walletProtocol: WalletProtocol, accounts: [CopyTradingAccountInfo], wallets: [WalletData], walletToAccount: Bool, currency: CurrencyType) {
        self.router = router
        self.walletProtocol = walletProtocol
        self.accounts = accounts
        self.wallets = wallets
        self.walletToAccount = walletToAccount
        
        setup(currency)
    }
    
    private func setup(_ currency: CurrencyType) {
        guard let accounts = accounts, let wallets = wallets else { return }
        
        if let selectedCurrency = CopyTradingAccountInfo.Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
        }
        
        self.selectedWalletDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
        self.selectedWalletDelegateManager?.walletId = walletToAccount ? 0 : 1
        self.selectedWalletDelegateManager?.selected = wallets.first
        self.selectedWalletDelegateManager?.selectedIndex = 0
        
        self.selectedAccountDelegateManager = AccountsDepositCurrencyDelegateManager(accounts)
        self.selectedAccountDelegateManager?.walletId = walletToAccount ? 1 : 0
        accounts.enumerated().forEach { (index, account) in
            if account.currency == selectedCurrency {
                self.selectedAccountDelegateManager?.selected = account
                self.selectedAccountDelegateManager?.selectedIndex = index
            }
        }
        
        updateRate { [weak self] (result) in
            self?.walletProtocol?.didUpdateData()
        }
    }
    
    
    private func updateRate(completion: @escaping CompletionBlock) {
        guard let account = selectedAccountDelegateManager?.selected, let wallet = selectedWalletDelegateManager?.selected else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let from = walletToAccount ? wallet.currency?.rawValue ?? "" : account.currency?.rawValue ?? ""
        let to = !walletToAccount ? wallet.currency?.rawValue ?? "" : account.currency?.rawValue ?? ""
        
        RateDataProvider.getRate(from: from, to: to, completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func getFromCurreny() -> CurrencyType? {
        let walletCurrency: WalletData.Currency = selectedWalletDelegateManager?.selected?.currency ?? .gvt
        let accountCurrency: CopyTradingAccountInfo.Currency = selectedAccountDelegateManager?.selected?.currency ?? .gvt
        
        return CurrencyType(rawValue: walletToAccount ? walletCurrency.rawValue : accountCurrency.rawValue)
    }
    
    func getToCurreny() -> CurrencyType? {
        let walletCurrency: WalletData.Currency = selectedWalletDelegateManager?.selected?.currency ?? .gvt
        let accountCurrency: CopyTradingAccountInfo.Currency = selectedAccountDelegateManager?.selected?.currency ?? .gvt
        
        return CurrencyType(rawValue: !walletToAccount ? walletCurrency.rawValue : accountCurrency.rawValue)
    }
    
    func getFromCurreny() -> CurrencyType? {
        let walletCurrency: WalletData.Currency = selectedWalletDelegateManager?.selected?.currency ?? .gvt
        let accountCurrency: CopyTradingAccountInfo.Currency = selectedAccountDelegateManager?.selected?.currency ?? .gvt
        
        return CurrencyType(rawValue: walletToAccount ? walletCurrency.rawValue : accountCurrency.rawValue)
    }
    
    func getToCurreny() -> CurrencyType? {
        let walletCurrency: WalletData.Currency = selectedWalletDelegateManager?.selected?.currency ?? .gvt
        let accountCurrency: CopyTradingAccountInfo.Currency = selectedAccountDelegateManager?.selected?.currency ?? .gvt
        
        return CurrencyType(rawValue: !walletToAccount ? walletCurrency.rawValue : accountCurrency.rawValue)
    }
    
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let accounts = accounts, let wallets = wallets else { return }
        
        let walletSelectedIndex = selectedWalletDelegateManager?.selectedIndex ?? 0
        let accountSelectedIndex = selectedAccountDelegateManager?.selectedIndex ?? 0
        
        let oldIndex = walletToAccount ? walletSelectedIndex : accountSelectedIndex
        if walletToAccount {
            selectedWalletDelegateManager?.selectedIndex = selectedIndex
        } else {
            selectedAccountDelegateManager?.selectedIndex = selectedIndex
        }
        
        if selectedIndex == (walletToAccount ? accountSelectedIndex : walletSelectedIndex) {
            updateWalletCurrencyToIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        if walletToAccount {
            selectedWalletDelegateManager?.selected = wallets[selectedIndex]
        } else {
            selectedAccountDelegateManager?.selected = accounts[selectedIndex]
        }
        
        updateRate(completion: completion)
    }
    
    func updateWalletCurrencyToIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let accounts = accounts, let wallets = wallets else { return }
        
        let walletSelectedIndex = selectedWalletDelegateManager?.selectedIndex ?? 0
        let accountSelectedIndex = selectedAccountDelegateManager?.selectedIndex ?? 0

        guard (walletToAccount ? accountSelectedIndex : walletSelectedIndex) != selectedIndex else { return }
        
        let oldIndex = walletToAccount ? accountSelectedIndex : walletSelectedIndex
        if !walletToAccount {
            selectedWalletDelegateManager?.selectedIndex = selectedIndex
        } else {
            selectedAccountDelegateManager?.selectedIndex = selectedIndex
        }
        
        if selectedIndex == (walletToAccount ? walletSelectedIndex : accountSelectedIndex) {
            updateWalletCurrencyFromIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        if !walletToAccount {
            selectedWalletDelegateManager?.selected = wallets[selectedIndex]
        } else {
            selectedAccountDelegateManager?.selected = accounts[selectedIndex]
        }
        
        updateRate(completion: completion)
    }
    
    // MARK: - Navigation
    func transfer(with amount: Double, completion: @escaping CompletionBlock) {
        let sourceId = walletToAccount ? selectedWalletDelegateManager?.selected?.id : selectedAccountDelegateManager?.selected?.id
        let destinationId = !walletToAccount ? selectedWalletDelegateManager?.selected?.id : selectedAccountDelegateManager?.selected?.id
        
        WalletDataProvider.transfer(sourceId: sourceId, destinationId: destinationId, amount: amount, completion: completion)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}
