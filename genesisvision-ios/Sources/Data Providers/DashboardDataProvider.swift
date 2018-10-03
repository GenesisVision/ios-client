//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class DashboardDataProvider: DataProvider {
    static func getDashboardSummary(with assetId: UUID? = nil, from: Date? = nil, to: Date? = nil, type: InvestorAPI.ModelType_v10InvestorGet? = nil, assetType: InvestorAPI.AssetType_v10InvestorGet? = nil, skip: Int? = nil, take: Int? = nil, chartCurrency: InvestorAPI.ChartCurrency_v10InvestorGet? = nil, chartFrom: Date? = nil, chartTo: Date? = nil, requestsSkip: Int? = nil, requestsTake: Int? = nil, completion: @escaping (_ dashboardSummary: DashboardSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorGet(authorization: authorization, assetId: assetId, from: from, to: to, type: type, assetType: assetType, skip: skip, take: take, chartCurrency: chartCurrency, chartFrom: chartFrom, chartTo: chartTo, requestsSkip: requestsSkip, requestsTake: requestsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getDashboardPortfolioChart(with currency: InvestorAPI.Currency_v10InvestorPortfolioChartGet? = nil, from: Date? = nil, to: Date? = nil, completion: @escaping (_ dashboardChartValue: DashboardChartValue?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorPortfolioChartGet(authorization: authorization, currency: currency, from: from, to: to) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getDashboardPortfolioEvents(with assetId: UUID? = nil, from: Date? = nil, to: Date? = nil, type: InvestorAPI.ModelType_v10InvestorPortfolioEventsGet? = nil, assetType: InvestorAPI.AssetType_v10InvestorPortfolioEventsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ dashboardChartValue: DashboardPortfolioEvents?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorPortfolioEventsGet(authorization: authorization, assetId: assetId, from: from, to: to, type: type, assetType: assetType, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getProgramList(with sorting: InvestorAPI.Sorting_v10InvestorProgramsGet? = nil, from: Date? = nil, to: Date? = nil, chartPointsCount: Int? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorProgramsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programList: ProgramsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsGet(authorization: authorization,
                                           sorting: sorting,
                                           from: from,
                                           to: to,
                                           chartPointsCount: chartPointsCount,
                                           currencySecondary: currencySecondary,
                                           skip: skip,
                                           take: take) { (programList, error) in
                                            DataProvider().responseHandler(programList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getFundList(with sorting: InvestorAPI.Sorting_v10InvestorFundsGet? = nil, from: Date? = nil, to: Date? = nil, chartPointsCount: Int? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorFundsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programList: FundsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsGet(authorization: authorization,
                                        sorting: sorting,
                                        from: from,
                                        to: to,
                                        chartPointsCount: chartPointsCount,
                                        currencySecondary: currencySecondary,
                                        skip: skip,
                                        take: take) { (programList, error) in
                                            DataProvider().responseHandler(programList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
