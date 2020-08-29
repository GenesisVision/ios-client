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
    var assetId: String?
    var fundCurrency: CurrencyType? = .usd
    var walletCurrency: CurrencyType?
    var labelPlaceholder: String = "0"
    var levelsParamsInfo: LevelsParamsInfo?
    var fundDetailsFull: FundDetailsFull?
    var investmentCommission: Double?
    var minInvestAmountIntoFund: [AmountWithCurrency]?

    var walletId: UUID?
    var walletSummary: WalletSummary?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private weak var detailProtocol: ReloadDataProtocol?
    
    private var router: FundInvestRouter!
    
    // MARK: - Init
    init(withRouter router: FundInvestRouter, assetId: String, detailProtocol: ReloadDataProtocol?) {
        self.router = router
        self.assetId = assetId
        self.detailProtocol = detailProtocol
        self.fundCurrency = CurrencyType.gvt
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletSummary = walletSummary,
            let wallets = walletSummary.wallets else { return }
        
        self.selectedWalletFromDelegateManager?.selected = wallets[selectedIndex]
        self.selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        self.walletCurrency = CurrencyType(rawValue: wallets[selectedIndex].currency?.rawValue ?? "")
        
        updateRate(completion: completion)
    }
    
    private func getWallet(completion: @escaping CompletionBlock) {
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            if let wallet = wallet, let wallets = wallet.wallets {
                self?.walletSummary = wallet
                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
                self?.selectedWalletFromDelegateManager?.walletId = 0
                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
                self?.selectedWalletFromDelegateManager?.selected = wallets[0]
                self?.walletCurrency = CurrencyType(rawValue: wallets[0].currency?.rawValue ?? "")
                self?.getLevelsParamsInfo(completion: completion)
            }
        }, completionError: completion)
    }
    
    private func getLevelsParamsInfo(completion: @escaping CompletionBlock) {
        PlatformManager.shared.getLevelsParamsInfo(currency: .usdt) { [weak self] (viewModel) in
            self?.levelsParamsInfo = viewModel
            self?.getPlatformInfoAndFundDetails(completion: completion)
        }
    }
    
    private func getPlatformInfoAndFundDetails(completion: @escaping CompletionBlock) {
        PlatformManager.shared.getPlatformInfo { [weak self] (platformCommonInfo) in
            self?.investmentCommission = platformCommonInfo?.commonInfo?.platformCommission?.investment
            self?.minInvestAmountIntoFund = platformCommonInfo?.assetInfo?.fundInfo?.minInvestAmountIntoFund
            self?.updateRate(completion: completion)
            
            guard let assetId = self?.assetId else { return }
            
            FundsDataProvider.get(assetId, currencyType: .usdt, completion: { (details) in
                self?.fundDetailsFull = details
                completion(.success)
            }, errorCompletion: completion)
        }
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        
        getWallet(completion: completion)
        
        
//        AuthManager.getWallet(completion: { [weak self] (wallet) in
//            if let wallet = wallet, let wallets = wallet.wallets {
//                self?.walletSummary = wallet
//                self?.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
//                self?.selectedWalletFromDelegateManager?.walletId = 0
//                self?.selectedWalletFromDelegateManager?.selectedIndex = 0
//                self?.selectedWalletFromDelegateManager?.selected = wallets[0]
//                self?.walletCurrency = CurrencyType(rawValue: wallets[0].currency?.rawValue ?? "")
//                completion(.success)
//            }
//
//            PlatformManager.shared.getLevelsParamsInfo(currency: .usdt) { [weak self] (viewModel) in
//                self?.levelsParamsInfo = viewModel
//
//                PlatformManager.shared.getPlatformInfo { [weak self] (platformCommonInfo) in
//                    self?.investmentCommission = platformCommonInfo?.commonInfo?.platformCommission?.investment
//                    self?.updateRate(completion: completion)
//
//                    guard let assetId = self?.assetId else { return }
//
//                    FundsDataProvider.get(assetId, currencyType: .usdt, completion: { (details) in
//                        self?.fundDetailsFull = details
//                    }, errorCompletion: completion)
//                }
//            }
//            }, completionError: completion)
    }
    
    func getInvestmentAmountCurrencyValue(_ amount: Double) -> String {
        guard let fundCurrency = fundCurrency?.rawValue, let currencyType = CurrencyType(rawValue: fundCurrency) else { return "" }
        let value = amount * rate
        return "≈" + value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinInvestmentAmountText() -> String {
        guard let fundCurrency = fundCurrency, let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return "" }
        
        let minInvestmentAmount = getMinInvestmentAmount()
        
        var text = "min " + minInvestmentAmount.rounded(with: fundCurrency).toString() + " " + fundCurrency.rawValue
        
        if fundCurrency.rawValue != walletCurrency, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) {
            let minValueInWalletCurrency = (minInvestmentAmount / rate).rounded(with: walletCurrencyType).toString() + " " + walletCurrencyType.rawValue
            text.append("≈\(minValueInWalletCurrency)")
            return " (\(text))"
        }
        
        return text
    }
    
    func getMinInvestmentAmount() -> Double {
        guard let selectedCurrency = self.selectedWalletFromDelegateManager?.selected?.currency, let amountWithCurrency = minInvestAmountIntoFund?.first(where: {
            guard let currency = $0.currency else { return false }
            return currency == selectedCurrency
        }), let minInvestmentAmount = amountWithCurrency.amount  else { return 0.0 }
        
        return minInvestmentAmount
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
    
    func getGVCommision() -> Double {
        guard let gvCommission = investmentCommission else { return 0.0 }
        return gvCommission
    }
    
    func getEntryFee() -> Double {
        guard let entryFee = fundDetailsFull?.entryFeeCurrent else { return 0.0 }
        
        return entryFee
    }
    
    func getApproximateAmount(_ amount: Double) -> Double {
        return amount * rate
    }
    
    // MARK: - Private methods
    private func updateRate(completion: @escaping CompletionBlock) {
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue ?? "", to: fundCurrency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate?.rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didReloadData()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, completion: @escaping CompletionBlock) {
        guard let walletId = selectedWalletFromDelegateManager?.selected?._id else { return }
        FundsDataProvider.invest(withAmount: value, assetId: assetId, walletId: walletId) { (result) in
            completion(result)
        }
    }
}
