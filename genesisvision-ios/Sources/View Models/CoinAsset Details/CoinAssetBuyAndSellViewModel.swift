//
//  CoinAssetBuyViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 29.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation

protocol CoinAssetBuyAndSellViewModelProtocol {
    var coinAsset: CoinsAsset? { get }
    var amount: Double { get set }
    var wallet: WalletData? { get }
    var currency: Currency { get }
    var commission : Double { get }
    var whatUserGetValue : Double { get }
    var rate: Double? { get }
    var walletDepositCurrencyDelegate: WalletDepositCurrencyDelegateManager? { get set }
    func getWalletSummary(currency: Currency?, completion: @escaping (_ wallet: WalletSummary?) -> (), completionError: @escaping CompletionBlock)
    func getAssetAvailable() -> Double?
    func updateSelectedWallet(index : Int)
}

class CoinAssetBuyAndSellViewModel: CoinAssetBuyAndSellViewModelProtocol {
    private let asset: CoinsAsset?
    private var walletSummary: WalletSummary?
    private var feePercent = 0.0
    private var amountValue: Double = 0.0
    var commission: Double {
        guard let currencyRate = currencyRate else { return 0.0 }
        return amountValue * feePercent * currencyRate
    }
    private var selectedCurrency: Currency = .gvt {
        didSet {
            if asset?.asset != selectedCurrency.rawValue {
                feePercent = Constants.CoinAssetsConstants.fee
            } else {
                feePercent = 0.0
            }
            updateCurrencyRate()
        }
    }
    private var wallets: [WalletData]?
    private var selectedWallet: WalletData? {
        didSet {
            guard let currency = selectedWallet?.currency else { return }
            selectedCurrency = currency
            amountValue = 0.0
        }
    }
    private var ratesModel: RatesModel? {
        didSet {
            updateCurrencyRate()
        }
    }
    private var currencyRate: Double?
    var whatUserGetValue: Double {
        guard let currencyRate = currencyRate else { return 0.0 }
        return amountValue * currencyRate - commission
    }
    private var walletDepositCurrencyDelegateManager: WalletDepositCurrencyDelegateManager?
    
    init(asset: CoinsAsset) {
        self.asset = asset
    }
    // MARK: - TODO Check memory leak
    
    func getWalletSummary(currency: Currency?, completion: @escaping (_ wallet: WalletSummary?) -> (), completionError: @escaping CompletionBlock) {
        
        WalletDataProvider.get(with: currency ?? getPlatformCurrencyType()) { viewModel in
            if viewModel != nil  {
                self.walletSummary = viewModel
                self.wallets = viewModel?.wallets
                self.walletDepositCurrencyDelegateManager = WalletDepositCurrencyDelegateManager(viewModel?.wallets ?? [WalletData]())
                self.selectedWallet = viewModel?.wallets?.first(where: {$0.currency == self.selectedCurrency})
                self.getRates { ratesModel in
                    self.ratesModel = ratesModel
                    completion(viewModel)
                }
            }
        } errorCompletion: { result in
            completionError(result)
        }
    }
    
    private func getRates(completion: @escaping (_ ratesModel: RatesModel?) -> ()) {
        guard let asset = asset?.asset else { return }
        let from = wallets?.compactMap({$0.currency?.rawValue})
        let to = [asset]
        RateDataProvider.getRates(from: from, to: to, completion: { ratesModel in
            completion(ratesModel)
        }, errorCompletion: {result in
            print("Rates error : ", result)
        })
    }
    
    private func updateCurrencyRate() {
        guard let currency = asset?.asset else { return }
        let currencyArray = ratesModel?.rates?[selectedCurrency.rawValue]
        let currencyRate = currencyArray?.first(where: {$0.currency == currency})?.rate
        self.currencyRate = currencyRate
    }
    
    func getAssetAvailable() -> Double? {
        let wallet = wallets?.first(where: {$0.currency?.rawValue == asset?.asset})
        return wallet?.available
    }
    
    func updateSelectedWallet(index : Int) {
        guard let wallet = wallets?[index] else { return }
        selectedWallet = wallet
    }
}

//MARK: - CoinAssetBuyAndSellViewModelProtocol
extension CoinAssetBuyAndSellViewModel {
    var walletDepositCurrencyDelegate: WalletDepositCurrencyDelegateManager? {
        get {
            walletDepositCurrencyDelegateManager
        }
        set {
            walletDepositCurrencyDelegateManager = newValue
        }
    }
    var rate: Double? {
        currencyRate
    }
    var currency: Currency {
        selectedCurrency
    }
    var wallet: WalletData? {
        selectedWallet
    }
    var amount: Double {
        get {
            amountValue
        }
        set {
            amountValue = newValue
        }
    }
    var coinAsset: CoinsAsset? {
        asset
    }
}


