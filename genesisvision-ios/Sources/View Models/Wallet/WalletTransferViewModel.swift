//
//  WalletTransferViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

final class WalletTransferViewModel {
    // MARK: - Variables
    var title: String = "Transfer"
    var disclaimer = "The funds will be converted according to the current market price (Market order on Binance)."
    private weak var walletProtocol: WalletProtocol?
    
    var labelPlaceholder: String = "0"
    var walletMultiSummary: WalletMultiSummary?
    
    //from
    var selectedCurrencyFrom: WalletData.Currency = .gvt
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    //to
    var selectedCurrencyTo: WalletData.Currency = .btc
    var selectedWalletToDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private var router: WalletRouter!
    
    // MARK: - Init
    init(withRouter router: WalletRouter, walletProtocol: WalletProtocol, currencyFrom: CurrencyType, currencyTo: CurrencyType, walletMultiSummary: WalletMultiSummary?) {
        self.router = router
        self.walletProtocol = walletProtocol
        self.walletMultiSummary = walletMultiSummary
        
        setup(currencyFrom: currencyFrom, currencyTo: currencyTo)
    }
    
    private func setup(currencyFrom: CurrencyType, currencyTo: CurrencyType) {
        if let wallets = walletMultiSummary?.wallets {
            if let selectedCurrency = WalletData.Currency(rawValue: currencyFrom.rawValue) {
                self.selectedCurrencyFrom = selectedCurrency
            }
            
            if let selectedCurrency = WalletData.Currency(rawValue: currencyTo.rawValue) {
                self.selectedCurrencyTo = selectedCurrency
            }
            
            self.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
            self.selectedWalletFromDelegateManager?.walletId = 0
            self.selectedWalletFromDelegateManager?.selectedWallet = walletMultiSummary?.wallets?.first(where: { $0.currency == selectedCurrencyFrom })
            self.selectedWalletFromDelegateManager?.selectedIndex = walletMultiSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrencyFrom }) ?? 0
            self.selectedWalletToDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
            self.selectedWalletToDelegateManager?.walletId = 1
            self.selectedWalletToDelegateManager?.selectedWallet = walletMultiSummary?.wallets?.first(where: { $0.currency == selectedCurrencyTo })
            self.selectedWalletToDelegateManager?.selectedIndex = walletMultiSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrencyTo }) ?? 0
        }
        
        updateRate { [weak self] (result) in
            self?.walletProtocol?.didUpdateData()
        }
    }
    
    
    private func updateRate(completion: @escaping CompletionBlock) {
        guard let from = selectedWalletFromDelegateManager?.selectedWallet, let to = selectedWalletToDelegateManager?.selectedWallet else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        RateDataProvider.getRate(from: from.currency?.rawValue ?? "", to: to.currency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else { return }
        
        let oldIndex = selectedWalletFromDelegateManager?.selectedIndex ?? 0
        selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        if selectedIndex == selectedWalletToDelegateManager?.selectedIndex {
            updateWalletCurrencyToIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        selectedWalletFromDelegateManager?.selectedWallet = wallets[selectedWalletFromDelegateManager?.selectedIndex ?? 0]
        updateRate(completion: completion)
    }
    
    func updateWalletCurrencyToIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets, selectedWalletToDelegateManager?.selectedIndex != selectedIndex else { return }
        
        let oldIndex = selectedWalletToDelegateManager?.selectedIndex ?? 0
        selectedWalletToDelegateManager?.selectedIndex = selectedIndex
        
        if selectedIndex == selectedWalletFromDelegateManager?.selectedIndex {
            updateWalletCurrencyFromIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        selectedWalletToDelegateManager?.selectedWallet = wallets[selectedIndex]
        updateRate(completion: completion)
    }
    
    // MARK: - Navigation
    func transfer(with amount: Double, completion: @escaping CompletionBlock) {
        guard let sourceId = selectedWalletFromDelegateManager?.selectedWallet?.id, let destinationId = selectedWalletToDelegateManager?.selectedWallet?.id else { return }
        
        WalletDataProvider.transfer(sourceId: sourceId, destinationId: destinationId, amount: amount, completion: completion)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}

