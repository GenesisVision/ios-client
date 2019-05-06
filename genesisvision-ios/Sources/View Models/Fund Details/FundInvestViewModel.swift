//
//  FundInvestViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class FundInvestViewModel {
    // MARK: - Variables
    var title: String = "Investment"
    var fundId: String?
    var fundCurrency: CurrencyType? = .usd
    var labelPlaceholder: String = "0"
    
    var fundInvestInfo: FundInvestInfo?

    var walletMultiSummary: WalletMultiSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private weak var detailProtocol: DetailProtocol?
    
    private var router: FundInvestRouter!
    
    // MARK: - Init
    init(withRouter router: FundInvestRouter, fundId: String, detailProtocol: DetailProtocol?) {
        self.router = router
        self.fundId = fundId
        self.detailProtocol = detailProtocol
        self.fundCurrency = CurrencyType(rawValue: getSelectedCurrency()) ?? .usd
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else { return }
        
        self.selectedWalletFromDelegateManager?.selectedWallet = wallets[selectedIndex]
        self.selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        updateRate(completion: completion)
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        guard let fundId = fundId,
            let fundCurrencyValue = fundCurrency?.rawValue,
            let currencySecondary = InvestorAPI.Currency_v10InvestorFundsByIdInvestInfoByCurrencyGet(rawValue: fundCurrencyValue)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletMultiSummary = wallet
                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                self?.selectedWalletFromDelegateManager?.walletId = 0
                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                self?.selectedWalletFromDelegateManager?.selectedWallet = wallets[0]
            }
            
            FundsDataProvider.getInvestInfo(fundId: fundId, currencySecondary: currencySecondary, completion: { [weak self] (fundInvestInfo) in
                guard let fundInvestInfo = fundInvestInfo else {
                    return completion(.failure(errorType: .apiError(message: nil)))
                }
                
                self?.fundInvestInfo = fundInvestInfo
                self?.updateRate(completion: completion)
                completion(.success)
                }, errorCompletion: completion)
            }, completionError: completion)
    }
    
    func getInvestmentAmountCurrencyValue(_ amount: Double) -> String {
        guard let fundCurrency = fundCurrency?.rawValue, let currencyType = CurrencyType(rawValue: fundCurrency) else { return "" }
        let value = amount * rate
        return "≈" + value.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinInvestmentAmountText() -> String {
        guard let fundCurrency = fundCurrency, let walletCurrency = self.selectedWalletFromDelegateManager?.selectedWallet?.currency?.rawValue else { return "" }
        
        let minInvestmentAmount = getMinInvestmentAmount()
        
        var text = "min " + minInvestmentAmount.rounded(withType: fundCurrency).toString() + " " + fundCurrency.rawValue
        
        if fundCurrency.rawValue != walletCurrency, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) {
            let minValueInWalletCurrency = (minInvestmentAmount / rate).rounded(withType: walletCurrencyType).toString() + " " + walletCurrencyType.rawValue
            text.append("≈\(minValueInWalletCurrency)")
            return " (\(text))"
        }
        
        return text
    }
    
    func getMinInvestmentAmount() -> Double {
        guard let minInvestmentAmount = fundInvestInfo?.minInvestmentAmount else { return 0.0 }
        
        return minInvestmentAmount
    }
    
    func getSelectedWalletTitle() -> String {
        guard let title = self.selectedWalletFromDelegateManager?.selectedWallet?.title, let currency = self.selectedWalletFromDelegateManager?.selectedWallet?.currency?.rawValue else {
            return ""
        }
        
        return title + " | " + currency
    }
    
    func getMaxAmount() -> Double {
        return getAvailableInWallet()
    }
    
    func getAvailableInWallet() -> Double {
        guard let available = self.selectedWalletFromDelegateManager?.selectedWallet?.available else { return 0.0 }
        
        return available
    }
    
    func getGVCommision() -> Double {
        guard let gvCommission = fundInvestInfo?.gvCommission else { return 0.0 }
        
        return gvCommission
    }
    
    func getEntryFee() -> Double {
        guard let entryFee = fundInvestInfo?.entryFee else { return 0.0 }
        
        return entryFee
    }
    
    func getApproximateAmount(_ amount: Double) -> Double {
        return amount * rate
    }
    
    // MARK: - Private methods
    private func updateRate(completion: @escaping CompletionBlock) {
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selectedWallet?.currency?.rawValue ?? "", to: fundCurrency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didInvested()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, completion: @escaping CompletionBlock) {
        guard let walletCurrency = self.selectedWalletFromDelegateManager?.selectedWallet?.currency?.rawValue else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = InvestorAPI.Currency_v10InvestorFundsByIdInvestByAmountPost(rawValue: walletCurrency)
        
        FundsDataProvider.invest(withAmount: value, fundId: fundId, currency: currency, errorCompletion: { (result) in
            completion(result)
        })
    }
}
