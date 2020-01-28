//
//  AccountDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class AccountsDataProvider: DataProvider {
    // MARK: - Details
    static func get(_ accountId: String, completion: @escaping (_ privateTradingAccountFull: PrivateTradingAccountFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: accountId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        TradingaccountAPI.getTradingAccountDetails(id: uuid, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Charts
    static func getProfitPercentCharts(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: CurrencyType?, currencies: [String]?, completion: @escaping (_ data: AccountProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = TradingaccountAPI.Currency_getProfitPercentCharts(rawValue: currencyType?.rawValue ?? "")
        
        TradingaccountAPI.getProfitPercentCharts(id: uuid, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency, currencies: currencies) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getBalanceChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: CurrencyType?, completion: @escaping (_ data: AccountBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = TradingaccountAPI.Currency_getBalanceChart(rawValue: currencyType?.rawValue ?? "")
        
        TradingaccountAPI.getBalanceChart(id: uuid, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getAbsoluteProfitChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: CurrencyType?, completion: @escaping (_ data: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let currency = TradingaccountAPI.Currency_getAbsoluteProfitChart(rawValue: currencyType?.rawValue ?? "")
        
        TradingaccountAPI.getAbsoluteProfitChart(id: uuid, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Trades
    static func getTrades(with id: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: TradingaccountAPI.Sorting_getTrades? = nil, accountId: UUID? = nil, currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: id), let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = TradingaccountAPI.AccountCurrency_getTrades(rawValue: currency?.rawValue ?? "")
        
        TradingaccountAPI.getTrades(id: uuid, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTradesOpen(with id: String, sorting: TradingaccountAPI.Sorting_getOpenTrades?, symbol: String? = nil, accountId: UUID? = nil, currency: CurrencyType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesSignalViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: id), let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let accountCurrency = TradingaccountAPI.AccountCurrency_getOpenTrades(rawValue: currency?.rawValue ?? "")
        
        TradingaccountAPI.getOpenTrades(id: uuid, authorization: authorization, sorting: sorting, symbol: symbol, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    
}


