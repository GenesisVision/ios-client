//
//  WalletAccountsTransferViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

final class WalletsAccountsTransferViewModel {
    enum TransferType {
        case from
        case to
    }
    
    // MARK: - Variables
    var title: String = "Transfer"
    var disclaimer = "The funds will be converted according to the current market price (via market order on Binance)."
    var labelPlaceholder: String = "0"
    
    private weak var walletProtocol: WalletProtocol?
    
    var accounts: [TradingAccountDetails]?
    var wallets: [WalletData]?
    
    var selectedCurrency: TradingAccountDetails.Currency?

    var selectedAccountDelegateManager: AccountsDepositCurrencyDelegateManager?
    var selectedWalletDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    var type: WalletTransferType = .fromWallet
    
    private var router: WalletRouter!
    
    // MARK: - Init
    init(withRouter router: WalletRouter, walletProtocol: WalletProtocol, accounts: [TradingAccountDetails], wallets: [WalletData], type: WalletTransferType, currency: CurrencyType) {
        self.router = router
        self.walletProtocol = walletProtocol
        self.accounts = accounts
        self.wallets = wallets
        self.type = type
        
        setup(currency)
    }
    
    private func setup(_ currency: CurrencyType) {
        guard let accounts = accounts, let wallets = wallets else { return }
        
        if let selectedCurrency = TradingAccountDetails.Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
        }
        
        self.selectedWalletDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
        self.selectedWalletDelegateManager?.walletId = type == .fromWallet ? 0 : 1
        self.selectedWalletDelegateManager?.selected = wallets.first
        self.selectedWalletDelegateManager?.selectedIndex = 0
        
        self.selectedAccountDelegateManager = AccountsDepositCurrencyDelegateManager(accounts)
        self.selectedAccountDelegateManager?.walletId = type == .fromWallet ? 1 : 0
        accounts.enumerated().forEach { (index, account) in
            if account.currency == self.selectedCurrency {
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
        
        var from = ""
        var to = ""
        
        switch type {
        case .fromWallet:
            from = wallet.currency?.rawValue ?? ""
            to = account.currency?.rawValue ?? ""
        case .fromAccount:
            from = account.currency?.rawValue ?? ""
            to = wallet.currency?.rawValue ?? ""
        }
        
        RateDataProvider.getRate(from: from, to: to, completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    private func getWalletTitle() -> String {
        return selectedWalletDelegateManager?.selected!.title ?? ""
    }
    
    private func getAccountTitle() -> String {
        return selectedAccountDelegateManager?.selected!.title ?? ""
    }
    
    // MARK: - Public methods
    func getAvailable(_ transferType: TransferType) -> Double {
        guard let availableWallet = selectedWalletDelegateManager?.selected?.available,
            let availableAccount = selectedAccountDelegateManager?.selected?.available else { return 0.0 }
        
        switch type {
        case .fromWallet:
            return transferType == .from ? availableWallet : availableAccount
        case .fromAccount:
            return transferType == .from ? availableAccount : availableWallet
        }
    }
    
    func getTitle(_ transferType: TransferType) -> String {
        guard let currency = getCurrency(transferType)?.rawValue else { return "" }
        
        let titleWallet = getWalletTitle() + " | " + currency
        let titleAccount = getAccountTitle() + " | " + currency
        
        switch type {
        case .fromWallet:
             return transferType == .from ? titleWallet : titleAccount
        case .fromAccount:
            return transferType == .from ? titleAccount : titleWallet
        }
    }
    
    func getCurrency(_ transferType: TransferType) -> CurrencyType? {
        guard let walletCurrency: WalletData.Currency = selectedWalletDelegateManager?.selected?.currency,
            let accountCurrency: TradingAccountDetails.Currency = selectedAccountDelegateManager?.selected?.currency,
            let walletCurrencyType = CurrencyType(rawValue: walletCurrency.rawValue),
            let accountCurrencyType = CurrencyType(rawValue: accountCurrency.rawValue) else { return nil }
        
        switch type {
        case .fromWallet:
            return transferType == .from ? walletCurrencyType : accountCurrencyType
        case .fromAccount:
            return transferType == .from ? accountCurrencyType : walletCurrencyType
        }
    }
    
    func updateSelectedIndex(_ transferType: TransferType) {
        switch type {
        case .fromWallet:
            transferType == .from ? selectedWalletDelegateManager?.updateSelectedIndex() : selectedAccountDelegateManager?.updateSelectedIndex()
        case .fromAccount:
            transferType == .from ? selectedAccountDelegateManager?.updateSelectedIndex() : selectedWalletDelegateManager?.updateSelectedIndex()
        }
    }
    
    func getDelegateManager(_ transferType: TransferType) -> CurrencyDelegateManagerProtocol? {
        switch type {
        case .fromWallet:
            return transferType == .from ? selectedWalletDelegateManager : selectedAccountDelegateManager
        case .fromAccount:
            return transferType == .from ? selectedAccountDelegateManager : selectedWalletDelegateManager
        }
    }
    
    
    
    func updateWalletSelectedIndex(_ transferType: TransferType, _ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let accounts = accounts, let wallets = wallets else { return }
        
        switch type {
        case .fromWallet:
            if transferType == .from {
                selectedWalletDelegateManager?.selectedIndex = selectedIndex
                selectedWalletDelegateManager?.selected = wallets[selectedIndex]
            } else {
                selectedAccountDelegateManager?.selectedIndex = selectedIndex
                selectedAccountDelegateManager?.selected = accounts[selectedIndex]
            }
        case .fromAccount:
            if transferType == .from {
                selectedAccountDelegateManager?.selectedIndex = selectedIndex
                selectedAccountDelegateManager?.selected = accounts[selectedIndex]
            } else {
                selectedWalletDelegateManager?.selectedIndex = selectedIndex
                selectedWalletDelegateManager?.selected = wallets[selectedIndex]
            }
        }
        
        updateRate(completion: completion)
    }
    
    // MARK: - Navigation
    func transfer(with amount: Double, completion: @escaping CompletionBlock) {
        
        let sourceId = type == .fromWallet ? selectedWalletDelegateManager?.selected?.id : selectedAccountDelegateManager?.selected?.id
        let destinationId = type == .fromWallet ? selectedAccountDelegateManager?.selected?.id : selectedWalletDelegateManager?.selected?.id
        
        let sourceType: InternalTransferRequest.SourceType = type == .fromWallet ? .wallet : .copyTradingAccount
        let destinationType: InternalTransferRequest.DestinationType = type == .fromWallet ? .copyTradingAccount : .wallet
        
        WalletDataProvider.transfer(sourceId: sourceId, sourceType: sourceType, destinationId: destinationId, destinationType: destinationType, amount: amount, completion: completion)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}
