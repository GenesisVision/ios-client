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
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.updateSubscriptionSettings(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func attach(on programId: String, model: AttachToSignalProvider, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.attachSlaveToMasterInternal(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func attachAccounts(assetId: String, completion: @escaping (_ copyTradingAccountsList: TradingAccountDetailsItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.getSubscriberAccountsForAsset(_id: uuid) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func attachExternalPrivateAccount(uuid: UUID, model: AttachToExternalSignalProviderExt? = nil, completion: @escaping CompletionBlock) {
        
        SignalAPI.attachSlaveToMasterExternalPrivateAccount(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }

    static func detach(with programId: String, model: DetachFromSignalProvider, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        SignalAPI.detachSlaveFromMasterInternal(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func detachExternal(with programId: String, model: DetachFromExternalSignalProvider, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        SignalAPI.detachSlaveFromMasterExternal(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getTradesLog(_ currency: CurrencyType? = nil, accountId: UUID? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ signalTradingEvents: SignalTradingEventItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let accountCurrency = Currency(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.getSignalTradingLog(accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}

