//
//  CreateAccountViewModel.swift
//  genesisvision-ios
//
//  Created by George on 28/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

final class OldCreateAccountViewModel {
    // MARK: - Variables
    var title: String = "Account creation"
    var assetId: String?
    var programCurrency: CurrencyType?
    var labelPlaceholder: String = "0"
    var leverage: Int?
    var walletSummary: WalletSummary?
    var walletMultiAvailable: WalletMultiAvailable?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    var completion: CreateAccountCompletionBlock?
    var brokerId: UUID?
    
    private var router: ProgramInfoRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInfoRouter, assetId: String, brokerId: UUID?, leverage: Int?, programCurrency: CurrencyType, completion: @escaping CreateAccountCompletionBlock) {
        self.router = router
        self.brokerId = brokerId
        self.leverage = leverage
        self.assetId = assetId
        self.programCurrency = programCurrency
        self.completion = completion
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletSummary = walletSummary,
            let wallets = walletSummary.wallets else { return }
        
        self.selectedWalletFromDelegateManager?.selected = wallets[selectedIndex]
        self.selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        updateRate(completion: completion)
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletSummary = wallet
                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                self?.selectedWalletFromDelegateManager?.walletId = 0
                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                self?.selectedWalletFromDelegateManager?.selected = wallets[0]
            }
            
            self?.updateRate(completion: completion)
            }, completionError: completion)
    }
    
    func getInvestmentAmountCurrencyValue(_ amount: Double) -> String {
        guard let programCurrency = programCurrency?.rawValue, let currencyType = CurrencyType(rawValue: programCurrency) else { return "" }
        let value = amount * rate
        return "≈" + value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getSelectedWalletTitle() -> String {
        guard let title = self.selectedWalletFromDelegateManager?.selected?.title, let currency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else {
            return ""
        }
        
        return title + " | " + currency
    }
    
    func getMaxAmount() -> Double {
        return getAvailableInWallet()
    }
    
    func getAvailableInWallet() -> Double {
        guard let available = self.selectedWalletFromDelegateManager?.selected?.available else { return 0.0 }
        
        return available
    }
    
    func getApproximateAmount(_ amount: Double) -> Double {
        return amount * rate
    }
    
    // MARK: - Private methods
    private func updateRate(completion: @escaping CompletionBlock) {
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue ?? "", to: programCurrency?.rawValue ?? "", completion: { [weak self] (rateModel) in
            self?.rate = rateModel?.rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func create(_ initialDepositAmount: Double) {
        guard let wallet = selectedWalletFromDelegateManager?.selected else { return }
        let request = NewTradingAccountRequest(depositAmount: initialDepositAmount, depositWalletId: wallet.id, currency: wallet.currency, leverage: leverage, brokerAccountTypeId: brokerId)
        
        AssetsDataProvider.createTradingAccount(request, completion: { [weak self] (viewModel) in
            self?.completion?(viewModel?.id)
        }) { (result) in
            print(result)
        }
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
}
