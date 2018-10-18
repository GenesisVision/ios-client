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
    
    var currency = CreateWithdrawalRequestModel.Currency.gvt
    
    private var router: WalletWithdrawRouter!
    
    var selectedWalletCurrency: String?
    var selectedWalletCurrencyIndex: Int {
//        guard let selectedWalletCurrency = selectedWalletCurrency,
//            let walletCurrencies = brokersViewModel?.brokers,
//            let idx = brokers.index(where: {$0.brokerId == selectedBrokerTradeServer.brokerId}) else {
//                return 0
//        }
//
//        return idx
        return 0
    }
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter, walletProtocol: WalletProtocol) {
        self.router = router
        self.walletProtocol = walletProtocol
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
//        guard let brokersViewModel = brokersViewModel,
//            let brokers = brokersViewModel.brokers else {
//                return
//        }
//
//        for found in brokers.enumerated() {
//            if found.offset == selectedIndex {
//                selectedBrokerTradeServer = found.element
//
//                if let idx = editableFields.index(where: { $0.type == .brokerServer }),
//                    let selectedBrokerTradeServer = selectedBrokerTradeServer,
//                    let brokerId = selectedBrokerTradeServer.id,
//                    let name = selectedBrokerTradeServer.name {
//                    temparyNewInvestmentRequest?.brokerTradeServerId = brokerId
//                    editableFields[idx].text = name
//                }
//            }
//        }
    }
    
    // MARK: - Picker View Values
    func walletCurrencyValues() -> [String] {
//        guard let brokersViewModel = brokersViewModel,
//            let brokers = brokersViewModel.brokers else {
//                return []
//        }
//
//        return brokers.map { $0.name ?? "" }
        
        return []
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, address: String, currency: CreateWithdrawalRequestModel.Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, address: address, currency: currency, twoFactorCode: twoFactorCode, completion: completion)
    }
    
    func readQRCode(completion: @escaping CompletionBlock) {
        router.show(routeType: .readQRCode)
    }
    
    func showWalletWithdrawRequested() {
        //TODO: showWalletWithdrawRequested
    }
    
    func goToBack() {
        walletProtocol?.didWithdrawn()
        router.goToBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, address: String, currency: CreateWithdrawalRequestModel.Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }

        let requestModel = CreateWithdrawalRequestModel(amount: amount, currency: currency, address: address, twoFactorCode: twoFactorCode)
        
        WalletAPI.v10WalletWithdrawRequestNewPost(authorization: token, model: requestModel) { [weak self] (error) in
            self?.responseHandler(error, completion: completion)
        }
    }
    
    private func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        if let error = error {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}



