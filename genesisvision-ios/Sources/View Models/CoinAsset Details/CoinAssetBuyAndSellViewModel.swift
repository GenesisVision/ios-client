//
//  CoinAssetBuyViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 29.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

protocol CoinAssetBuyAndSellViewModelProtocol {
    var coinAsset: CoinsAsset? { get }
    var amount: Double { get set }
    var wallet: WalletData? { get }
    var currency: Currency { get }
    var commission : Double { get }
    var whatUserGetValue : Double { get }
    var rate: Double? { get }
    var isBuyVC: Bool { get }
    var walletDepositCurrencyDelegate: WalletDepositCurrencyDelegateManager? { get set }
    var alertControllerDelegate: AlertControllerDelegateProtocol? { get set }
    func getWalletSummary(currency: Currency?, completion: @escaping (_ wallet: WalletSummary?) -> (), completionError: @escaping CompletionBlock)
    func updateSelectedWallet(index : Int)
    func transfer(navigationController: UINavigationController?)
}

protocol AlertControllerDelegateProtocol {
    func showAlert(title: String?, massage: String?)
}

class CoinAssetBuyAndSellViewModel: CoinAssetBuyAndSellViewModelProtocol {
    let isBuyViewController: Bool
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
    var walletDepositCurrencyDelegate: WalletDepositCurrencyDelegateManager?
    var alertControllerDelegate: AlertControllerDelegateProtocol?
    
    init(asset: CoinsAsset, isBuyViewController: Bool = true) {
        self.asset = asset
        self.isBuyViewController = isBuyViewController
    }
    // MARK: - TODO Check memory leak
    
    func getWalletSummary(currency: Currency?, completion: @escaping (_ wallet: WalletSummary?) -> (), completionError: @escaping CompletionBlock) {
        
        WalletDataProvider.get(with: currency ?? getPlatformCurrencyType()) { viewModel in
            if viewModel != nil  {
                self.walletSummary = viewModel
                self.wallets = viewModel?.wallets
                self.walletDepositCurrencyDelegate = WalletDepositCurrencyDelegateManager(viewModel?.wallets ?? [WalletData]())
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
        let from: [String]?
        let to: [String]?
        if isBuyViewController {
            from = wallets?.compactMap({$0.currency?.rawValue})
            to = [asset]
        } else {
            from = [asset]
            to = wallets?.compactMap({$0.currency?.rawValue})
        }
        RateDataProvider.getRates(from: from, to: to, completion: { ratesModel in
            completion(ratesModel)
        }, errorCompletion: {result in
            print("Rates error : ", result)
        })
    }
    
    private func updateCurrencyRate() {
        guard let currency = asset?.asset else { return }
        if isBuyViewController {
            let currencyArray = ratesModel?.rates?[selectedCurrency.rawValue]
            let currencyRate = currencyArray?.first(where: {$0.currency == currency})?.rate
            self.currencyRate = currencyRate
        } else {
            let currencyArray = ratesModel?.rates?[currency]
            let currencyRate = currencyArray?.first(where: {$0.currency == selectedCurrency.rawValue})?.rate
            self.currencyRate = currencyRate
        }
    }
    
    func updateSelectedWallet(index : Int) {
        guard let wallet = wallets?[index] else { return }
        selectedWallet = wallet
    }
    //MARK: - TODO Check memory leak
    
    func transfer(navigationController: UINavigationController?) {
        guard let asset = asset, let currency = asset.asset else { return }
        let from : [String]?
        let to : [String]?
        
        if isBuyViewController {
            from = [selectedCurrency.rawValue]
            to = [Currency.usd.rawValue]
        } else {
            from = [currency]
            to = [Currency.usd.rawValue]
        }
        
        RateDataProvider.getRates(from: from, to: to, completion: { [self] ratesModel in
            guard let from = from?.first, let to = to?.first else { return }
            let rateItems = ratesModel?.rates?[from]
            let usd = rateItems?.first(where: {$0.currency == to})?.rate

            guard let usd = usd, (usd * self.amount) >= 10 else {
                alertControllerDelegate?.showAlert(title: Constants.CoinAssetsConstants.minimalTransferDisclaimer, massage: nil)
                return }
            
            var body : InternalTransferRequest?
            let assetId : UUID?
            
            if let oefAssetId = asset.oefAssetId {
                assetId = oefAssetId
            } else {
                assetId = asset._id
            }
            
            guard assetId != nil, let selectedWalletID = self.selectedWallet?._id else {
                alertControllerDelegate?.showAlert(title: Constants.CoinAssetsConstants.transferError, massage: nil)
                return
            }
            let amount = self.amountValue
            switch self.isBuyViewController {
            case true:
                body = InternalTransferRequest(sourceId: selectedWalletID, sourceType: .wallet, destinationId: assetId, destinationType: .coinsMarket, amount: amount)
            case false:
                body = InternalTransferRequest(sourceId: assetId, sourceType: .coinsMarket, destinationId: selectedWalletID, destinationType: .wallet, amount: amount)
            }
            
            CoinAssetsDataProvider.transfer(body: body) { data, error in
                if error == nil {
                    CoinAssetRouter.showDetailViewControllerAfterConfirmingTransaction(navigationController: navigationController)
                } else {
                    alertControllerDelegate?.showAlert(title: Constants.CoinAssetsConstants.transferError, massage: nil)
                }
            }
            
        }, errorCompletion: { [self] result in
            print("Rates error : ", result)
            alertControllerDelegate?.showAlert(title: Constants.CoinAssetsConstants.minimalTransferDisclaimer, massage: nil)
        })
    }
}

//MARK: - CoinAssetBuyAndSellViewModelProtocol
extension CoinAssetBuyAndSellViewModel {
    var isBuyVC: Bool {
        isBuyViewController
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


