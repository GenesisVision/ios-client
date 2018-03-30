//
//  WalletDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDataProvider: DataProvider {
    // MARK: - Public methods
    static func getWallet(completion: @escaping (_ wallet: WalletsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        isInvestorApp
            ? getInvestorWallet(with: authorization, completion: completion, errorCompletion: errorCompletion)
            : getManagerWallet(with: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getWalletTransactions(with filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        isInvestorApp
            ? getInvestorWalletTransactions(with: authorization, filter: filter, completion: completion, errorCompletion: errorCompletion)
            : getManagerWalletTransactions(with: authorization, filter: filter, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getWalletAddress(completion: @escaping (_ walletAddressViewModel: WalletAddressViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        InvestorAPI.apiInvestorWalletAddressGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Private methods
    private static func getInvestorWallet(with authorization: String, completion: @escaping (_ wallets: WalletsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorWalletGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerWallet(with authorization: String, completion: @escaping (_ wallets: WalletsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerWalletGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getInvestorWalletTransactions(with authorization: String, filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorWalletTransactionsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerWalletTransactions(with authorization: String, filter: TransactionsFilter, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerWalletTransactionsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
