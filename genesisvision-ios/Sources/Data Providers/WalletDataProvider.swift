//
//  WalletDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDataProvider: DataProvider {
    // MARK: - Get methods
    static func getMulti(with currency: WalletAPI.Currency_v10WalletMultiByCurrencyGet, completion: @escaping (_ wallet: WalletMultiSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletMultiByCurrencyGet(currency: currency, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTransactionDetails(with id: UUID, completion: @escaping (_ transactions: TransactionDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletTransactionByIdGet(id: id, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getMultiTransactions(from: Date? = nil, to: Date? = nil, type: WalletAPI.ModelType_v10WalletMultiTransactionsGet? = nil, currency: WalletAPI.Currency_v10WalletMultiTransactionsGet?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: MultiWalletTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletMultiTransactionsGet(authorization: authorization, from: from, to: to, type: type, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getMultiExternalTransactions(from: Date? = nil, to: Date? = nil, type: WalletAPI.ModelType_v10WalletMultiTransactionsExternalGet? = nil, currency: WalletAPI.Currency_v10WalletMultiTransactionsExternalGet?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: MultiWalletExternalTransactionsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.v10WalletMultiTransactionsExternalGet(authorization: authorization, from: from, to: to, type: type, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWithdrawInfo(completion: @escaping (_ withdrawalSummary: WithdrawalSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletWithdrawInfoGet(authorization: authorization) { (withdrawalSummary, error) in
            DataProvider().responseHandler(withdrawalSummary, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getAddresses(completion: @escaping (_ walletsInfo: WalletsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletAddressesGet(authorization: authorization) { (walletsInfo, error) in
            DataProvider().responseHandler(walletsInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Post methods
    static func feeChange(_ value: Bool, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        value ?
            WalletAPI.v10WalletPaygvtfeeOnPost(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
            }
            :
            WalletAPI.v10WalletPaygvtfeeOffPost(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func transfer(sourceId: UUID?, sourceType: InternalTransferRequest.SourceType = .wallet, destinationId: UUID?, destinationType: InternalTransferRequest.DestinationType = .wallet, amount: Double?, transferAll: Bool? = false, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let request = InternalTransferRequest(sourceId: sourceId, sourceType: sourceType, destinationId: destinationId, destinationType: destinationType, amount: amount, transferAll: transferAll)
        
        WalletAPI.v10WalletTransferPost(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func createWithdrawalRequest(with amount: Double, address: String, currency: CreateWithdrawalRequestModel.Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let requestModel = CreateWithdrawalRequestModel(amount: amount, currency: currency, address: address, twoFactorCode: twoFactorCode)
        
        WalletAPI.v10WalletWithdrawRequestNewPost(authorization: authorization, model: requestModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func cancelWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletWithdrawRequestCancelByTxIdPost(txId: txId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func resendWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.v10WalletWithdrawRequestResendByTxIdPost(txId: txId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func confirmWithdrawalRequest(with requestId: UUID, code: String?, completion: @escaping CompletionBlock) {
        
        WalletAPI.v10WalletWithdrawRequestConfirmPost(requestId: requestId, code: code) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
