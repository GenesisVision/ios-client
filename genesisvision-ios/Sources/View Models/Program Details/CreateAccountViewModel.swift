//
//  CreateAccountViewModel.swift
//  genesisvision-ios
//
//  Created by George on 28/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

final class CreateAccountViewModel {
    // MARK: - Variables
    var title: String = "Account creation"
    var programId: String?
    var programCurrency: CurrencyType?
    var labelPlaceholder: String = "0"
    
    var walletMultiSummary: WalletMultiSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    var completion: CreateAccountCompletionBlock?
    
    private var router: ProgramInfoRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInfoRouter, programId: String, programCurrency: CurrencyType, completion: @escaping CreateAccountCompletionBlock) {
        self.router = router
        self.programId = programId
        self.programCurrency = programCurrency
        self.completion = completion
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else { return }
        
        self.selectedWalletFromDelegateManager?.selected = wallets[selectedIndex]
        self.selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        updateRate(completion: completion)
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletMultiSummary = wallet
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
        return "≈" + value.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
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
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue ?? "", to: programCurrency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func next(_ initialDepositAmount: Double) {
        guard let programId = programId, let currency = selectedWalletFromDelegateManager?.selected?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .subscribe(programId: programId, initialDepositCurrency: currencyType, initialDepositAmount: initialDepositAmount))
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
}
