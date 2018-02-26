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
    
    private var router: WalletWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func withdraw(with amount: Double, address: String, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, address: address, completion: completion)
    }
    
    func readQRCode(completion: @escaping CompletionBlock) {
        router.show(routeType: .readQRCode)
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, address: String, completion: @escaping CompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }

        completion(.success)
//        let investModel = Invest(investmentProgramId: uuid, amount: value)
        
//        InvestorAPI.apiInvestorInvestmentsWithdrawPost(authorization: token, model: investModel) { [weak self] (error) in
//            self?.responseHandler(error, completion: completion)
//        }
    }
}



