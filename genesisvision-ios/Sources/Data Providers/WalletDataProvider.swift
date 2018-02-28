//
//  WalletDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class WalletDataProvider: DataProvider {
    // MARK: - Public methods
    static func getWallet(completion: @escaping (_ wallet: WalletsViewModel?) -> Void) {
        guard let token = AuthManager.authorizedToken else { return completion(nil) }
        
        isInvestorApp
            ? getInvestorWallet(with: token) { (viewModel) in
                completion(viewModel)
                }
            : getManagerWallet(with: token) { (viewModel) in
                completion(viewModel)
        }
    }
    
    static func getWalletTransactions(authorization: String, filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void) {
        isInvestorApp
            ? getInvestorWalletTransactions(with: authorization, filter: filter) { (viewModel) in
                completion(viewModel)
                }
            : getManagerWalletTransactions(with: authorization, filter: filter) { (viewModel) in
                completion(viewModel)
        }
    }
    
    // MARK: - Private methods
    private static func getInvestorWallet(with authorization: String, completion: @escaping (_ wallets: WalletsViewModel?) -> Void) {
        InvestorAPI.apiInvestorWalletGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (walletsViewModel) in
                completion(walletsViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerWallet(with authorization: String, completion: @escaping (_ wallets: WalletsViewModel?) -> Void) {
        ManagerAPI.apiManagerWalletGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (walletsViewModel) in
                completion(walletsViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getInvestorWalletTransactions(with authorization: String, filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void) {
        InvestorAPI.apiInvestorWalletTransactionsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (transactionsViewModel) in
                completion(transactionsViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerWalletTransactions(with authorization: String, filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void) {
        ManagerAPI.apiManagerWalletTransactionsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (transactionsViewModel) in
                completion(transactionsViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}
