//
//  FundWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//
import Foundation

final class FundWithdrawViewModel {
    
    // MARK: - Variables
    var title: String = "Withdraw"
    var assetId: String?
    var labelPlaceholder: String = "0"
    
    var fundWithdrawInfo: FundWithdrawInfo?
    
    var walletSummary: WalletSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    var rate: Double = 0.0
    
    private weak var detailProtocol: DetailProtocol?
    
    private var router: FundWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: FundWithdrawRouter,
         assetId: String,
         detailProtocol: DetailProtocol?) {
        self.router = router
        self.assetId = assetId
        self.detailProtocol = detailProtocol
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
        var currency: InvestmentsAPI.Currency_getFundWithdrawInfo = .gvt
        
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletSummary = wallet
                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                self?.selectedWalletFromDelegateManager?.walletId = 0
                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                self?.selectedWalletFromDelegateManager?.selected = wallets[0]
            }
            
            if let walletCurrency = self?.selectedWalletFromDelegateManager?.selected?.currency?.rawValue {
                currency = InvestmentsAPI.Currency_getFundWithdrawInfo(rawValue: walletCurrency) ?? .gvt
            }
            
            FundsDataProvider.getWithdrawInfo(assetId, currency: currency, completion: { [weak self] (fundWithdrawInfo) in
                guard let fundWithdrawInfo = fundWithdrawInfo else {
                    return completion(.failure(errorType: .apiError(message: nil)))
                }
                
                self?.fundWithdrawInfo = fundWithdrawInfo
                self?.updateRate(completion: completion)
                }, errorCompletion: completion)
            }, completionError: completion)
    }
    
    func getWithdrawalAmountCurrencyValue(_ amount: Double) -> String {
        guard let selectedWalletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let currencyType = CurrencyType(rawValue: selectedWalletCurrency) else { return "" }
        let value = amount * getAvailableToWithdraw() / 100
        return "≈" + value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinWithdrawalAmountText() -> String {

        return "Amount must be greater than or equal to \(getMinWithdrawalAmount())"
    }
    
    func getMinWithdrawalAmount() -> Double {
        return 0.01
    }
    
    func getSelectedWalletTitle() -> String {
        guard let title = self.selectedWalletFromDelegateManager?.selected?.title, let currency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else {
            return ""
        }
        
        return title + " | " + currency
    }
    
    func getMaxAmount() -> Double {
        return 100
    }
    
    func getAvailableToWithdraw() -> Double {
        guard let available = fundWithdrawInfo?.availableToWithdraw else { return 0.0 }
        
        return available / rate
    }
    
    func getExitFee() -> Double {
        guard let exitFee = fundWithdrawInfo?.exitFee else { return 0.0 }
        
        return exitFee
    }
    
    func getApproximateAmount(_ amount: Double) -> Double {
        return amount * getAvailableToWithdraw()
    }
    
    // MARK: - Private methods
    private func updateRate(completion: @escaping CompletionBlock) {
        //TODO: change "GVT"
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue ?? "", to: "GVT", completion: { [weak self] (rate) in
            self?.rate = rate?.rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        guard let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = InvestmentsAPI.Currency_withdrawFromFund(rawValue: walletCurrency)
        
        FundsDataProvider.withdraw(withPercent: amount, assetId: assetId, currency: currency) { (result) in
            completion(result)
        }
    }
    
    func goToBack() {
        detailProtocol?.didReload()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
}
