//
//  WalletViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class WalletViewModel {
    
    // MARK: - Variables
    var title: String = "Wallet"
    
    private var router: WalletRouter!
    private var transactions: WalletTransactionsViewModel?
    private var profileViewModel: ProfileShortViewModel? {
        didSet {
            balance = profileViewModel?.balance ?? 0.0
        }
    }
    private var balance: Double = 0.0
    
    // MARK: - Init
    init(withRouter router: WalletRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func withdraw() {
        router.show(routeType: .withdraw)
    }
    
    // MARK: - Data methods
    func getBalance() -> Double {
        return balance
    }
    
    func fetch(completion: @escaping ApiCompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        isInvestorApp
            ? InvestorAPI.apiInvestorProfileGet(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.profileViewModel = viewModel
                completion(.success)
            }
            : ManagerAPI.apiManagerProfileGet(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.profileViewModel = viewModel
                completion(ApiCompletionResult.success)
            }
    }
    
    func loadTransactions(completion: @escaping ApiCompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        isInvestorApp
            ? InvestorAPI.apiInvestorWalletTransactionsPost(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.transactions = viewModel
                completion(.success)
                }
            : ManagerAPI.apiManagerWalletTransactionsPost(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.transactions = viewModel
                completion(.success)
        }
    }
}

