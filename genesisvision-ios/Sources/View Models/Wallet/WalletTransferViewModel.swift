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
    var selectedWalletFrom: WalletData?
    var selectedWalletFromCurrencyIndex: Int = 0
    var selectedCurrencyFrom: WalletData.Currency = .gvt
    //to
    var selectedWalletTo: WalletData?
    var selectedWalletToCurrencyIndex: Int = 0
    var selectedCurrencyTo: WalletData.Currency = .btc
    
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
        self.selectedWalletFrom = walletMultiSummary?.wallets?.first(where: { $0.currency == selectedCurrencyFrom })
        self.selectedWalletFromCurrencyIndex = walletMultiSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrencyFrom }) ?? 0
        
        self.selectedWalletTo = walletMultiSummary?.wallets?.first(where: { $0.currency == selectedCurrencyTo })
        self.selectedWalletToCurrencyIndex = walletMultiSummary?.wallets?.firstIndex(where: { $0.currency == selectedCurrencyTo }) ?? 0
        
        if let selectedCurrency = WalletData.Currency(rawValue: currencyFrom.rawValue) {
            self.selectedCurrencyFrom = selectedCurrency
        }
        
        if let selectedCurrency = WalletData.Currency(rawValue: currencyTo.rawValue) {
            self.selectedCurrencyTo = selectedCurrency
        }
        
        updateRate { [weak self] (result) in
            self?.walletProtocol?.didUpdateData()
        }
    }
    
    
    private func updateRate(completion: @escaping CompletionBlock) {
        RateDataProvider.getRate(from: selectedWalletFrom?.currency?.rawValue ?? "", to: selectedWalletTo?.currency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate ?? 0.0
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else { return }
        
        let oldIndex = selectedWalletFromCurrencyIndex
        selectedWalletFromCurrencyIndex = selectedIndex
        
        if selectedIndex == selectedWalletToCurrencyIndex {
            updateWalletCurrencyToIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        selectedWalletFrom = wallets[selectedWalletFromCurrencyIndex]
        updateRate(completion: completion)
    }
    
    func updateWalletCurrencyToIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets, selectedWalletToCurrencyIndex != selectedIndex else { return }
        
        let oldIndex = selectedWalletToCurrencyIndex
        selectedWalletToCurrencyIndex = selectedIndex
        
        if selectedIndex == selectedWalletFromCurrencyIndex {
            updateWalletCurrencyFromIndex(oldIndex) { (result) in
                print(result)
            }
        }
        
        selectedWalletTo = wallets[selectedIndex]
        updateRate(completion: completion)
    }
    
    // MARK: - Picker View Values
    func walletCurrencyValues() -> [String] {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else {
                return []
        }
        
        return wallets.map {
            if let title = $0.title , let currency = $0.currency?.rawValue {
                return title + " | " + currency
            }
            
            return ""
        }
    }
    
    // MARK: - Navigation
    func transfer(with amount: Double, completion: @escaping CompletionBlock) {
        guard let sourceId = selectedWalletFrom?.id, let destinationId = selectedWalletTo?.id else { return }
        
        WalletDataProvider.transfer(sourceId: sourceId, destinationId: destinationId, amount: amount, completion: completion)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}

