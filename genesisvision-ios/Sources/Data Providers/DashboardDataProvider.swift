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
    static func getChart(with assets: [UUID]?, dateFrom: Date?, dateTo: Date?, chartPointsCount: Int?, showIn: Currency?, completion: @escaping (DashboardChart?) -> Void, errorCompletion: @escaping CompletionBlock) {

        DashboardAPI.getChart(assets: assets, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: showIn) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getChartAssets(completion: @escaping (DashboardChartAssets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getChartAssets { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
      
    // MARK: - Holdings
    static func getHoldings(_ topAssetsCount: Int?, completion: @escaping (DashboardAssets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getHoldings(topAssetsCount: topAssetsCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Investing
    static func getInvesting(_ currency: Currency, eventsTake: Int?, completion: @escaping (DashboardInvestingDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {


        DashboardAPI.getInvestingDetails(currency: currency, eventsTake: eventsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestingFunds(_ sorting: FundsFilterSorting? = nil, currency: Currency?, status: DashboardAssetStatus?, dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, facetId: String? = nil, mask: String? = nil, ownerId: UUID? = nil, showFavorites: Bool? = nil, skip: Int?, take: Int?, completion: @escaping (FundInvestingDetailsListItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getInvestingFunds(sorting: sorting, showIn: currency, status: status, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, facetId: facetId, mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestingPrograms(_ sorting: ProgramsFilterSorting? = nil, currency: Currency?, status: DashboardAssetStatus?, dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, facetId: String? = nil, mask: String? = nil, ownerId: UUID? = nil, showFavorites: Bool? = nil, skip: Int?, take: Int?, completion: @escaping (ProgramInvestingDetailsListItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getInvestingPrograms(sorting: sorting, showIn: currency, status: status, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, facetId: facetId, mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Portfolio
    static func getPortfolio(completion: @escaping (DashboardPortfolio?) -> Void, errorCompletion: @escaping CompletionBlock) {

        DashboardAPI.getPortfolio { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Recommendations
    static func getRecommendations(_ currency: Currency, take: Int? = nil, completion: @escaping (CommonPublicAssetsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {

        DashboardAPI.getRecommendations(currency: currency, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Summary
//    static func getSummary(_ currency: Currency, completion: @escaping (DashboardSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
//
//
//        DashboardAPI.getSummary(currency: currency) { (viewModel, error) in
//            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
//        }
//    }
    
    // MARK: - Trading
    static func getTrading(_ currency: Currency, eventsTake: Int?, completion: @escaping (DashboardTradingDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {

        DashboardAPI.getTradingDetails(currency: currency, eventsTake: eventsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getMostProfitable(_ dateFrom: Date?, dateTo: Date?, chartPointsCount: Int?, currency: Currency?, completion: @escaping (DashboardTradingAssetItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getMostProfitableAssets(dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getPrivateTrading(_ dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, currency: Currency?, status: DashboardAssetStatus?, skip: Int?, take: Int?, completion: @escaping (DashboardTradingAssetItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getPrivateTradingAssets(dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: currency, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getPublicTrading(_ dateFrom: Date? = nil, dateTo: Date? = nil, chartPointsCount: Int? = nil, currency: Currency?, status: DashboardAssetStatus?, skip: Int?, take: Int?, completion: @escaping (DashboardTradingAssetItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        DashboardAPI.getPublicTradingAssets(dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: chartPointsCount, showIn: currency, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
