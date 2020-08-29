//
//  ProgramInvestViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramInvestViewModel {
    // MARK: - Variables
    var title: String = "Investment"
    var assetId: String?
    var programCurrency: CurrencyType?
    var walletCurrency: CurrencyType?
    var labelPlaceholder: String = "0"

    var walletSummary: WalletSummary?
    var levelsParamsInfo: LevelsParamsInfo?
    var programDetailsFull: ProgramDetailsFull?
    var programFollowDetailsFull: ProgramFollowDetailsFull?
    var investmentCommission: Double?
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    private var router: ProgramInvestRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInvestRouter, assetId: String, programCurrency: CurrencyType, detailProtocol: ReloadDataProtocol?) {
        self.router = router
        self.assetId = assetId
        self.programCurrency = programCurrency
        self.reloadDataProtocol = detailProtocol
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
                self?.getProgramsData(completion: completion)
            }
            }, completionError: completion)
    }
    
    private func getPlatformInfo(completion: @escaping CompletionBlock) {
        PlatformManager.shared.getLevelsParamsInfo(currency: .usdt) { [weak self] (viewModel) in
            self?.levelsParamsInfo = viewModel
            PlatformManager.shared.getPlatformInfo { [weak self] (platformCommonInfo) in
                self?.investmentCommission = platformCommonInfo?.commonInfo?.platformCommission?.investment
                self?.updateRate(completion: completion)
                completion(.success)
            }
        }
    }
    
    private func getProgramsData(completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return }
        ProgramsDataProvider.get(assetId, completion: { [weak self] (details) in
            self?.programFollowDetailsFull = details
            self?.programDetailsFull = details?.programDetails
            completion(.success)
            self?.getPlatformInfo(completion: completion)
        }, errorCompletion: completion)
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
//            }
//            PlatformManager.shared.getLevelsParamsInfo(currency: .usdt) { [weak self] (viewModel) in
//                self?.levelsParamsInfo = viewModel
//                PlatformManager.shared.getPlatformInfo { [weak self] (platformCommonInfo) in
//                    self?.investmentCommission = platformCommonInfo?.commonInfo?.platformCommission?.investment
//                    self?.updateRate(completion: completion)
//                    
//                    guard let assetId = self?.assetId else { return }
//                    
//                    ProgramsDataProvider.get(assetId, completion: { (details) in
//                        self?.programFollowDetailsFull = details
//                        self?.programDetailsFull = details?.programDetails
//                    }, errorCompletion: completion)
//                }
//            }
//            }, completionError: completion)
    }
    
    func getInvestmentAmountCurrencyValue(_ amount: Double) -> String {
        guard let programCurrency = programCurrency?.rawValue, let currencyType = CurrencyType(rawValue: programCurrency) else { return "" }
        let value = amount * rate
        return "≈" + value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinInvestmentAmountText() -> String {
        guard let programCurrency = programCurrency, let walletCurrency = self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue else { return "" }
        
        let minInvestmentAmount = getMinInvestmentAmount()
        
        var text = "min " + minInvestmentAmount.rounded(with: programCurrency).toString() + " " + programCurrency.rawValue
        
        if programCurrency.rawValue != walletCurrency, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) {
            let minValueInWalletCurrency = (minInvestmentAmount / rate).rounded(with: walletCurrencyType).toString() + " " + walletCurrencyType.rawValue
            text.append("≈\(minValueInWalletCurrency)")
            return " (\(text))"
        }
        
        return text
    }
    
    func getMinInvestmentAmount() -> Double {
        guard
            let minInvestAmounts = PlatformManager.shared.platformInfo?.assetInfo?.programInfo?.minInvestAmounts,
            let minInvestAmountIntoProgram = minInvestAmounts[0].minInvestAmountIntoProgram,
            let minInvestmentAmount = minInvestAmountIntoProgram.first(where: { $0.currency?.rawValue == programCurrency?.rawValue }) else { return 0.0 }
        
        return minInvestmentAmount.amount ?? 0.0
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
        guard let availableToInvestInProgramm = programDetailsFull?.availableInvestmentBase else { return 0.0 }
        
        return availableToInvestInProgramm
    }
    
    func getGVCommision() -> Double {
        guard let gvCommission = investmentCommission else { return 0.0 }
        
        return gvCommission
    }
    
    func getManagementFee() -> Double {
        guard let managementFee = programDetailsFull?.managementFeeCurrent else { return 0.0 }

        return managementFee
    }
    
    func getApproximateAmount(_ amount: Double) -> Double {
        return amount * rate
    }
    
    // MARK: - Private methods
    private func updateRate(completion: @escaping CompletionBlock) {
        RateDataProvider.getRate(from: self.selectedWalletFromDelegateManager?.selected?.currency?.rawValue ?? "", to: programCurrency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate?.rate ?? 0.0
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func invest(with value: Double, walletId: UUID, completion: @escaping CompletionBlock) {
        apiInvest(with: value, walletId: walletId, completion: completion)
    }
    
    func showInvestmentRequestedVC(investedAmount: Double) {
        reloadDataProtocol?.didReloadData()
        router.show(routeType: .investmentRequested(investedAmount: investedAmount))
    }
    
    func goToBack() {
        reloadDataProtocol?.didReloadData()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, walletId: UUID, completion: @escaping CompletionBlock) {
        ProgramsDataProvider.invest(withAmount: value, assetId: assetId, walletId: walletId, errorCompletion: completion)
    }
}
