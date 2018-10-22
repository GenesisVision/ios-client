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
    static func getWallet(with currency: WalletAPI.Currency_v10WalletByCurrencyGet, completion: @escaping (_ wallet: WalletSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletByCurrencyGet(currency: currency, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletTransactions(with assetId: UUID? = nil, from: Date? = nil, to: Date? = nil, assetType: WalletAPI.AssetType_v10WalletTransactionsGet? = nil, txAction: WalletAPI.TxAction_v10WalletTransactionsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: WalletTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletTransactionsGet(authorization: authorization, assetId: assetId, from: from, to: to, assetType: assetType, txAction: txAction, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletWithdrawInfo(completion: @escaping (_ withdrawalSummary: WithdrawalSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletWithdrawInfoGet(authorization: authorization) { (withdrawalSummary, error) in
            DataProvider().responseHandler(withdrawalSummary, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletAddresses(completion: @escaping (_ walletsInfo: WalletsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletAddressesGet(authorization: authorization) { (walletsInfo, error) in
            DataProvider().responseHandler(walletsInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletAddress(completion: @escaping (_ walletAddressViewModel: WalletsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletAddressesGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
