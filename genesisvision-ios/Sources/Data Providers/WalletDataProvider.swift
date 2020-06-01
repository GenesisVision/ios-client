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
    static func get(with currency: Currency, completion: @escaping (WalletSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.getWalletSummary(currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWalletAvailable(with currency: Currency, completion: @escaping (WalletMultiAvailable?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.getWalletAvailable(currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    static func updateDepositWallets(completion: @escaping (WalletDepositSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.updateDepositWallets { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Pay GVT Fee
    static func getGMCommission(completion: @escaping (UserCommissionData?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        WalletAPI.getGMCommissionData { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Transactions
    static func getTransactions(from: Date? = nil, to: Date? = nil, type: TransactionInternalType? = nil, currency: Currency?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: TransactionViewModelItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.getTransactionsInternal(transactionType: type, dateFrom: from, dateTo: to, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getExternalTransactions(from: Date? = nil, to: Date? = nil, type: TransactionExternalType? = nil, currency: Currency?, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ transactions: TransactionViewModelItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.getTransactionsExternal(transactionType: type, dateFrom: from, dateTo: to, currency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Transfer
    static func transfer(sourceId: UUID?, sourceType: InternalTransferRequestType = .wallet, destinationId: UUID?, destinationType: InternalTransferRequestType = .wallet, amount: Double?, transferAll: Bool? = false, completion: @escaping CompletionBlock) {
        
        let request = InternalTransferRequest(sourceId: sourceId, sourceType: sourceType, destinationId: destinationId, destinationType: destinationType, amount: amount, transferAll: transferAll)
        
        WalletAPI.transfer(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Withdraw
    static func getWithdrawInfo(completion: @escaping (_ withdrawalSummary: WithdrawalSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        WalletAPI.getUserWithdrawalSummary { (withdrawalSummary, error) in
            DataProvider().responseHandler(withdrawalSummary, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func cancelWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        
        WalletAPI.cancelWithdrawalRequest(txId: txId) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func confirmWithdrawalRequest(with requestId: UUID, code: String?, completion: @escaping CompletionBlock) {
        
        WalletAPI.confirmWithdrawalRequestByCode(requestId: requestId, code: code) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createWithdrawalRequest(with amount: Double, address: String, currency: Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        
        let requestModel = CreateWithdrawalRequestModel(amount: amount, currency: currency, address: address, twoFactorCode: twoFactorCode)
        
        WalletAPI.createWithdrawalRequest(body: requestModel) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func resendWithdrawalRequest(with txId: UUID, completion: @escaping CompletionBlock) {
        
        WalletAPI.resendWithdrawalRequestEmail(txId: txId) { (_, error) in
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
