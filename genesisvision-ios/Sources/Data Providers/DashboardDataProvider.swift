//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class DashboardDataProvider: DataProvider {
    // MARK: - Charts
    static func getChart(with assets: [UUID]?, dateFrom: Date?, dateTo: Date?, chartPointsCount: Int?, showIn: DashboardAPI.ShowIn_getChart?, completion: @escaping (DashboardChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getChart(authorization: authorization, assets: assets, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: showIn) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getChartAssets(completion: @escaping (DashboardChartAssets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        DashboardAPI.getChartAssets(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
      
    // MARK: - Holdings
    static func getHoldings(_ topAssetsCount: Int?, completion: @escaping (DashboardAssets?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getHoldings(authorization: authorization, topAssetsCount: topAssetsCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Investing
    static func getInvesting(_ currency: CurrencyType, eventsTake: Int?, completion: @escaping (DashboardInvestingDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken, let currency = DashboardAPI.Currency_getInvestingDetails(rawValue: currency.rawValue) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getInvestingDetails(authorization: authorization, currency: currency, eventsTake: eventsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestingFunds(_ sorting: DashboardAPI.Sorting_getInvestingFunds? = nil, currency: CurrencyType?, status: DashboardAPI.Status_getInvestingFunds?, dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, facetId: String? = nil, mask: String? = nil, ownerId: UUID? = nil, showFavorites: Bool? = nil, skip: Int?, take: Int?, completion: @escaping (ItemsViewModelFundInvestingDetailsList?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        var showIn: DashboardAPI.ShowIn_getInvestingFunds?
        if let currency = currency {
            showIn = DashboardAPI.ShowIn_getInvestingFunds(rawValue: currency.rawValue)
        }
        
        DashboardAPI.getInvestingFunds(authorization: authorization, sorting: sorting, showIn: showIn, status: status, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, facetId: facetId, mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestingPrograms(_ sorting: DashboardAPI.Sorting_getInvestingPrograms? = nil, currency: CurrencyType?, status: DashboardAPI.Status_getInvestingPrograms?, dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, facetId: String? = nil, mask: String? = nil, ownerId: UUID? = nil, showFavorites: Bool? = nil, skip: Int?, take: Int?, completion: @escaping (ItemsViewModelProgramInvestingDetailsList?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        var showIn: DashboardAPI.ShowIn_getInvestingPrograms?
        if let currency = currency {
            showIn = DashboardAPI.ShowIn_getInvestingPrograms(rawValue: currency.rawValue)
        }
        
        DashboardAPI.getInvestingPrograms(authorization: authorization, sorting: sorting, showIn: showIn, status: status, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, facetId: facetId, mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Portfolio
    static func getPortfolio(completion: @escaping (DashboardPortfolio?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getPortfolio(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Recommendations
    static func getRecommendations(_ currency: CurrencyType, take: Int? = nil, completion: @escaping (CommonPublicAssetsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken, let currency = DashboardAPI.Currency_getRecommendations(rawValue: currency.rawValue) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getRecommendations(authorization: authorization, currency: currency, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Summary
    static func getSummary(_ currency: CurrencyType, completion: @escaping (DashboardSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken, let currency = DashboardAPI.Currency_getSummary(rawValue: currency.rawValue) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        
        DashboardAPI.getSummary(authorization: authorization, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Trading
    static func getTrading(_ currency: CurrencyType, eventsTake: Int?, completion: @escaping (DashboardTradingDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken, let currency = DashboardAPI.Currency_getTradingDetails(rawValue: currency.rawValue) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        DashboardAPI.getTradingDetails(authorization: authorization, currency: currency, eventsTake: eventsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getMostProfitable(_ dateFrom: Date?, dateTo: Date?, chartPointsCount: Int?, currency: CurrencyType?, completion: @escaping (ItemsViewModelDashboardTradingAsset?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        var showIn: DashboardAPI.ShowIn_getMostProfitableAssets?
        if let currency = currency {
            showIn = DashboardAPI.ShowIn_getMostProfitableAssets(rawValue: currency.rawValue)
        }
        
        DashboardAPI.getMostProfitableAssets(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: showIn) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getPrivateTrading(_ dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, currency: CurrencyType?, status: DashboardAPI.Status_getPrivateTradingAssets?, skip: Int?, take: Int?, completion: @escaping (ItemsViewModelDashboardTradingAsset?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        var showIn: DashboardAPI.ShowIn_getPrivateTradingAssets?
        if let currency = currency {
            showIn = DashboardAPI.ShowIn_getPrivateTradingAssets(rawValue: currency.rawValue)
        }
        
        DashboardAPI.getPrivateTradingAssets(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: showIn, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getPublicTrading(_ dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, currency: CurrencyType?, status: DashboardAPI.Status_getPublicTradingAssets?, skip: Int?, take: Int?, completion: @escaping (ItemsViewModelDashboardTradingAsset?) -> Void, errorCompletion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        var showIn: DashboardAPI.ShowIn_getPublicTradingAssets?
        if let currency = currency {
            showIn = DashboardAPI.ShowIn_getPublicTradingAssets(rawValue: currency.rawValue)
        }
        
        DashboardAPI.getPublicTradingAssets(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: showIn, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
