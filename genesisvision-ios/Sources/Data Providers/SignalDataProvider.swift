//
//  SignalDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 23/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class SignalDataProvider: DataProvider {
    static func getAccounts(completion: @escaping (_ copyTradingAccountsList: CopyTradingAccountsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.v10SignalAccountsGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInfo(with programId: String, completion: @escaping (_ attachToSignalProviderInfo: AttachToSignalProviderInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.v10SignalAttachByIdInfoGet(id: uuid, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func subscribe(on programId: String, model: AttachToSignalProvider, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.v10SignalAttachByIdPost(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func unsubscribe(with programId: String, mode: DetachFromSignalProvider.Mode?, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        let model = DetachFromSignalProvider(mode: mode)
        SignalAPI.v10SignalDetachByIdPost(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func update(with programId: String, model: AttachToSignalProvider? = nil, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.v10SignalByIdUpdatePost(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getTradesLog(_ currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ signalTradingEvents: SignalTradingEvents?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = SignalAPI.AccountCurrency_v10SignalTradesLogGet(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.v10SignalTradesLogGet(authorization: authorization, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTradesOpen(with sorting: SignalAPI.Sorting_v10SignalTradesOpenGet?, symbol: String? = nil, currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesSignalViewModel: TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = SignalAPI.AccountCurrency_v10SignalTradesOpenGet(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.v10SignalTradesOpenGet(authorization: authorization, sorting: sorting, symbol: symbol, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTrades(from dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: SignalAPI.Sorting_v10SignalTradesGet? = nil, currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesSignalViewModel: TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = SignalAPI.AccountCurrency_v10SignalTradesGet(rawValue: currency?.rawValue ?? "")
        
        SignalAPI.v10SignalTradesGet(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func close(with programId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalAPI.v10SignalTradesByIdClosePost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}

