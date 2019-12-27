//
//  WalletDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDataProvider: DataProvider {
    // MARK: - Summary
    static func get(with currencyType: CurrencyType, completion: @escaping (WalletSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, let currency = WalletAPI.Currency_getWalletSummary(rawValue: currencyType.rawValue) else { return completion(nil) }
        
        WalletAPI.getWalletSummary(currency: currency, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletAvailable(with currency: WalletAPI.Currency_getWalletAvailable, completion: @escaping (WalletMultiAvailable?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.getWalletAvailable(currency: currency, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    static func updateDepositWallets(completion: @escaping (WalletDepositSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.updateDepositWallets(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Pay GVT Fee
    static func getGMCommission(completion: @escaping (UserCommissionData?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.getGMCommissionData(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func feeChange(_ value: Bool, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        value ?
            WalletAPI.switchPayFeeInGvtOn(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
            }
            :
            WalletAPI.switchPayFeeInGvtOff(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Transactions
    static func getTransactions(from: Date? = nil, to: Date? = nil, type: WalletAPI.TransactionType_getTransactionsInternal? = nil, currency: WalletAPI.Currency_getTransactionsInternal?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: ItemsViewModelTransactionViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.getTransactionsInternal(authorization: authorization, transactionType: type, dateFrom: from, dateTo: to, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getExternalTransactions(from: Date? = nil, to: Date? = nil, type: WalletAPI.TransactionType_getTransactionsExternal? = nil, currency: WalletAPI.Currency_getTransactionsExternal?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: ItemsViewModelTransactionViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        WalletAPI.getTransactionsExternal(authorization: authorization, transactionType: type, dateFrom: from, dateTo: to, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Transfer
    static func transfer(sourceId: UUID?, sourceType: InternalTransferRequestType = .wallet, destinationId: UUID?, destinationType: InternalTransferRequestType = .wallet, amount: Double?, transferAll: Bool? = false, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let request = InternalTransferRequest(sourceId: sourceId, sourceType: sourceType, destinationId: destinationId, destinationType: destinationType, amount: amount, transferAll: transferAll)
        
        WalletAPI.transfer(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Withdraw
    static func getWithdrawInfo(completion: @escaping (_ withdrawalSummary: WithdrawalSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        WalletAPI.getUserWithdrawalSummary(authorization: authorization) { (withdrawalSummary, error) in
            DataProvider().responseHandler(withdrawalSummary, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func cancelWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.cancelWithdrawalRequest(txId: txId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func confirmWithdrawalRequest(with requestId: UUID, code: String?, completion: @escaping CompletionBlock) {
        WalletAPI.confirmWithdrawalRequestByCode(requestId: requestId, code: code) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createWithdrawalRequest(with amount: Double, address: String, currency: Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let requestModel = CreateWithdrawalRequestModel(amount: amount, currency: currency, address: address, twoFactorCode: twoFactorCode)
        
        WalletAPI.createWithdrawalRequest(authorization: authorization, model: requestModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func resendWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        WalletAPI.resendWithdrawalRequestEmail(txId: txId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    
//    static func getAddresses(completion: @escaping (_ walletsInfo: WalletsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
//        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
//
//        WalletAPI.getWalletSummary(currency: <#T##WalletAPI.Currency_getWalletSummary#>, authorization: <#T##String#>) { (WalletSummary?, <#Error?#>) in
//            <#code#>
//        }
//        WalletAPI.v10WalletAddressesGet(authorization: authorization) { (walletsInfo, error) in
//            DataProvider().responseHandler(walletsInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
//        }
//    }
    
    
}
