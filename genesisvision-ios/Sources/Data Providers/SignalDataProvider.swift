//
//  SignalDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 23/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class SignalDataProvider: DataProvider {
    static func update(with programId: String, model: AttachToSignalProvider, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.updateSubscriptionSettings(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func attach(on programId: String, model: AttachToSignalProvider, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.attachSlaveToMasterInternal(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func attachAccounts(assetId: UUID, completion: @escaping (_ copyTradingAccountsList: ItemsViewModelTradingAccountDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.getSubscriberAccountsForAsset(id: assetId, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func attachExternalCommonAccount(uuid: UUID, model: AttachToExternalSignalProviderCommon? = nil, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.attachSlaveToMasterExternalCommonAccount(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func attachExternalPrivateAccount(uuid: UUID, model: AttachToExternalSignalProviderExt? = nil, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.attachSlaveToMasterExternalPrivateAccount(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }

    static func detach(with programId: String, model: DetachFromSignalProvider, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        SignalAPI.detachSlaveFromMasterInternal(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func detachExternal(with programId: String, model: DetachFromExternalSignalProvider, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        SignalAPI.detachSlaveFromMasterExternal(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func closeTrade(with tradeId: String, assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let tradeUuid = UUID(uuidString: tradeId), let assetUuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.closeTradeInternal(id: tradeUuid, authorization: authorization, assetId: assetUuid) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getTradesLog(_ currency: CurrencyType? = nil, accountId: UUID? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ signalTradingEvents: ItemsViewModelSignalTradingEvent?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = SignalAPI.AccountCurrency_getSignalTradingLog(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.getSignalTradingLog(authorization: authorization, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTradesOpen(with sorting: SignalAPI.Sorting_getOpenSignalTrades?, symbol: String? = nil, accountId: UUID? = nil, currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesSignalViewModel: TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = SignalAPI.AccountCurrency_getOpenSignalTrades(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.getOpenSignalTrades(authorization: authorization, sorting: sorting, symbol: symbol, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    
}

