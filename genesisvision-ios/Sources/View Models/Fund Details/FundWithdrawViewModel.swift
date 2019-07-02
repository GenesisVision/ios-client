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
    var fundId: String?
    var labelPlaceholder: String = "0"
    
    var fundWithdrawInfo: FundWithdrawInfo?
    
    var walletMultiSummary: WalletMultiSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    var rate: Double = 0.0
    
    private weak var detailProtocol: DetailProtocol?
    
    private var router: FundWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: FundWithdrawRouter,
         fundId: String,
         detailProtocol: DetailProtocol?) {
        self.router = router
        self.fundId = fundId
        self.detailProtocol = detailProtocol
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
        var currency: InvestorAPI.Currency_v10InvestorFundsByIdWithdrawInfoByCurrencyGet = .gvt
        
        guard let fundId = fundId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletMultiSummary = wallet
                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                self?.selectedWalletFromDelegateManager?.walletId = 0
                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                self?.selectedWalletFromDelegateManager?.selected = wallets[0]
            }
            
            if let walletCurrency = self?.selectedWalletFromDelegateManager?.selected?.currency?.rawValue {
                currency = InvestorAPI.Currency_v10InvestorFundsByIdWithdrawInfoByCurrencyGet(rawValue: walletCurrency) ?? .gvt
            }
            
            FundsDataProvider.getWithdrawInfo(fundId: fundId, currency: currency, completion: { [weak self] (fundWithdrawInfo) in
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
        return "≈" + value.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
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
            self?.rate = rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didReload()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, completion: @escaping CompletionBlock) {
        guard let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = InvestorAPI.Currency_v10InvestorFundsByIdWithdrawByPercentPost(rawValue: walletCurrency)
        
        FundsDataProvider.withdraw(withPercent: amount, fundId: fundId, currency: currency) { (result) in
            completion(result)
        }
    }
    
    private func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        if let error = error {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}
