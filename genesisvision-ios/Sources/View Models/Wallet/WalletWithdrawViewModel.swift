//
//  WalletWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class WalletWithdrawViewModel {
    // MARK: - Variables
    var title: String = "Withdraw"
    
    private weak var walletProtocol: WalletProtocol?
    
    var labelPlaceholder: String = "0"
    
    var withdrawalSummary: WithdrawalSummary? {
        didSet {
            self.selectedWallet = withdrawalSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
            self.selectedWalletCurrencyIndex = withdrawalSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrency }) ?? 0
        }
    }
    var selectedWallet: WalletWithdrawalInfo?

    private var router: WalletWithdrawRouter!
    
    var selectedWalletCurrencyIndex: Int = 0
    
    var selectedCurrency: WalletWithdrawalInfo.Currency = .gvt
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter, walletProtocol: WalletProtocol, currency: CurrencyType) {
        self.router = router
        self.walletProtocol = walletProtocol
        
        setup(currency)
    }
    
    private func setup(_ currency: CurrencyType) {
        if let selectedCurrency = WalletWithdrawalInfo.Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
            self.selectedWallet = withdrawalSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
            self.selectedWalletCurrencyIndex = withdrawalSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrency }) ?? 0
        }
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let withdrawalSummary = withdrawalSummary,
            let wallets = withdrawalSummary.wallets else { return }
        selectedWallet = wallets[selectedIndex]
        selectedWalletCurrencyIndex = selectedIndex
    }
    
    
    // MARK: - Picker View Values
    func walletCurrencyValues() -> [String] {
        guard let withdrawalSummary = withdrawalSummary,
            let wallets = withdrawalSummary.wallets else {
                return []
        }

        return wallets.map {
            if let description = $0.description, let currency = $0.currency?.rawValue {
                return description + " | " + currency
            }
            
            return ""
        }
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock) {
        WalletDataProvider.getWithdrawInfo(completion: { [weak self] (withdrawalSummary) in
            guard let withdrawalSummary = withdrawalSummary else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.withdrawalSummary = withdrawalSummary
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, address: String, currency: CreateWithdrawalRequestModel.Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        WalletDataProvider.createWithdrawalRequest(with: amount, address: address, currency: currency, twoFactorCode: twoFactorCode, completion: completion)
    }
    
    func readQRCode(completion: @escaping CompletionBlock) {
        router.show(routeType: .readQRCode)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}
