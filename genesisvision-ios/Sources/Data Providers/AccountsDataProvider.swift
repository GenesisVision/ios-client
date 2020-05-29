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
        
        guard let uuid = UUID(uuidString: accountId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        TradingaccountAPI.getTradingAccountDetails(_id: uuid) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Charts
    static func getProfitPercentCharts(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: Currency?, currencies: [Currency]?, completion: @escaping (_ data: AccountProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        TradingaccountAPI.getProfitPercentCharts(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currencyType, currencies: currencies) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getBalanceChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: Currency?, completion: @escaping (_ data: AccountBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        TradingaccountAPI.getBalanceChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currencyType) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getAbsoluteProfitChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: Currency?, completion: @escaping (_ data: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        TradingaccountAPI.getAbsoluteProfitChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currencyType) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Trades
    static func getTrades(with id: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: TradeSorting? = nil, accountId: UUID? = nil, currency: Currency? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: id) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
                
        TradingaccountAPI.getTrades(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTradesOpen(with id: String, sorting: TradeSorting?, symbol: String? = nil, accountId: UUID? = nil, currency: Currency? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesSignalViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: id) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
                
        TradingaccountAPI.getOpenTrades(_id: uuid, sorting: sorting, symbol: symbol, accountId: accountId, accountCurrency: currency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    
}


