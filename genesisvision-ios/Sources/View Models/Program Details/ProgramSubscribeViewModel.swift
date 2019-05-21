//
//  ProgramSubscribeViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 02.05.19.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramSubscribeViewModel {
    // MARK: - Variables
    var title: String = "Signal"
    var programId: String?
    var programCurrency: CurrencyType?
    var labelPlaceholder: String = "0"
    
    var programInvestInfo: ProgramInvestInfo?

    var walletMultiSummary: WalletMultiSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private var router: ProgramInvestRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInvestRouter, programId: String, programCurrency: CurrencyType) {
        self.router = router
        self.programId = programId
        self.programCurrency = programCurrency
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
        guard let programId = programId,
            let programCurrencyValue = programCurrency?.rawValue,
            let currencySecondary = InvestorAPI.Currency_v10InvestorProgramsByIdInvestInfoByCurrencyGet(rawValue: programCurrencyValue)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
            AuthManager.getWallet(completion: { [weak self] (wallet) in
                if let wallet = wallet, let wallets = wallet.wallets {
                    self?.walletMultiSummary = wallet
                    self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                    self?.selectedWalletFromDelegateManager?.walletId = 0
                    self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                    self?.selectedWalletFromDelegateManager?.selected = wallets[0]
                }
                
                ProgramsDataProvider.getInvestInfo(programId: programId, currencySecondary: currencySecondary, completion: { [weak self] (programInvestInfo) in
                    guard let programInvestInfo = programInvestInfo else {
                        return completion(.failure(errorType: .apiError(message: nil)))
                    }
                    
                    self?.programInvestInfo = programInvestInfo
                    self?.updateRate(completion: completion)
                    }, errorCompletion: completion)
            }, completionError: completion)
    }
    
    func getInvestmentAmountCurrencyValue(_ amount: Double) -> String {
        guard let programCurrency = programCurrency?.rawValue, let currencyType = CurrencyType(rawValue: programCurrency) else { return "" }
        let value = amount * rate
        return "≈" + value.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinInvestmentAmountText() -> String {
        guard let programCurrency = programCurrency, let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return "" }
        
        let minInvestmentAmount = getMinInvestmentAmount()
        
        var text = "min " + minInvestmentAmount.rounded(withType: programCurrency).toString() + " " + programCurrency.rawValue
        
        if programCurrency.rawValue != walletCurrency, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) {
            let minValueInWalletCurrency = (minInvestmentAmount / rate).rounded(withType: walletCurrencyType).toString() + " " + walletCurrencyType.rawValue
            text.append("≈\(minValueInWalletCurrency)")
            return " (\(text))"
        }
        
        return text
    }
    
    func getMinInvestmentAmount() -> Double {
        guard let minInvestmentAmount = programInvestInfo?.minInvestmentAmount else { return 0.0 }
        
        return minInvestmentAmount
    }
    
    func getSelectedWalletTitle() -> String {
        guard let title = self.selectedWalletFromDelegateManager?.selected?.title, let currency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else {
            return ""
        }
        
        return title + " | " + currency
    }
    
    func getMaxAmount() -> Double {
        return max(getAvailableInWallet(), getAvailableToInvest() / rate)
    }
    
    func getAvailableInWallet() -> Double {
        guard let available = self.selectedWalletFromDelegateManager?.selected?.available else { return 0.0 }
        
        return available
    }
    
    func getAvailableToInvest() -> Double {
        guard let available = programInvestInfo?.availableToInvestBase else { return 0.0 }
        
        return available
    }
    
    func getGVCommision() -> Double {
        guard let gvCommission = programInvestInfo?.gvCommission else { return 0.0 }
        
        return gvCommission
    }
    
    func getEntryFee() -> Double {
        guard let entryFee = programInvestInfo?.entryFee else { return 0.0 }
        
        return entryFee
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
    func subscribe(with value: Double, completion: @escaping CompletionBlock) {
        guard let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = InvestorAPI.Currency_v10InvestorProgramsByIdInvestByAmountPost(rawValue: walletCurrency)
        
//        SignalDataProvider.subscribe(with: <#T##String#>, completion: <#T##CompletionBlock##CompletionBlock##(CompletionResult) -> Void#>)
        ProgramsDataProvider.invest(withAmount: value, programId: programId, currency: currency, errorCompletion: completion)
    }
    
    func showSubscribeRequestedVC(subscribeAmount: Double) {
//        router.show(routeType: .investmentRequested(investedAmount: investedAmount))
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
}
