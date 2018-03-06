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
    
    var currency = WalletWithdrawRequestModel.Currency.gvt
    
    private var router: WalletWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter, walletProtocol: WalletProtocol) {
        self.router = router
        self.walletProtocol = walletProtocol
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func withdraw(with amount: Double, address: String, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, address: address, completion: completion)
    }
    
    func readQRCode(completion: @escaping CompletionBlock) {
        router.show(routeType: .readQRCode)
    }
    
    func goToBack() {
        walletProtocol?.didWithdrawn()
        router.goToBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, address: String, completion: @escaping CompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }

        let requestModel = WalletWithdrawRequestModel(currency: currency, amount: amount, blockchainAddress: address)
        
        InvestorAPI.apiInvestorWalletWithdrawRequestPost(authorization: token, request: requestModel) { [weak self] (error) in
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



