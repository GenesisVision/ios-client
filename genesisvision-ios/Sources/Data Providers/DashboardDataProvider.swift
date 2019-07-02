//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class DashboardDataProvider: DataProvider {
    static func getDashboardSummary(chartCurrency: InvestorAPI.ChartCurrency_v10InvestorGet?, from: Date?, to: Date?, balancePoints: Int?, programsPoints: Int?, eventsTake: Int?, requestsSkip: Int?, requestsTake: Int?, completion: @escaping (_ dashboardSummary: DashboardSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        InvestorAPI.v10InvestorGet(authorization: authorization, chartCurrency: chartCurrency, from: from, to: to, balancePoints: balancePoints, programsPoints: programsPoints, eventsTake: eventsTake, requestsSkip: requestsSkip, requestsTake: requestsTake) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getDashboardPortfolioChart(with currency: InvestorAPI.Currency_v10InvestorPortfolioChartGet? = nil, from: Date? = nil, to: Date? = nil, completion: @escaping (_ dashboardChartValue: DashboardChartValue?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorPortfolioChartGet(authorization: authorization, currency: currency, from: from, to: to) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getDashboardPortfolioEvents(with programId: String? = nil, from: Date? = nil, to: Date? = nil, type: InvestorAPI.ModelType_v10InvestorPortfolioEventsGet? = nil, assetType: InvestorAPI.AssetType_v10InvestorPortfolioEventsGet? = nil, skip: Int, take: Int, completion: @escaping (_ dashboardChartValue: DashboardPortfolioEvents?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        var uuid: UUID?
        
        if let programId = programId {
            uuid = UUID(uuidString: programId)
        }
        
        InvestorAPI.v10InvestorPortfolioEventsGet(authorization: authorization, assetId: uuid, from: from, to: to, type: type, assetType: assetType, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getProgramList(with sorting: InvestorAPI.Sorting_v10InvestorProgramsGet? = nil, from: Date? = nil, to: Date? = nil, chartPointsCount: Int? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorProgramsGet? = nil, onlyActive: Bool? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programList: ProgramsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        var dashboardActionStatus: InvestorAPI.DashboardActionStatus_v10InvestorProgramsGet = .all
        
        if let onlyActive = onlyActive {
            dashboardActionStatus = onlyActive ? .active : .all
        }
        
        InvestorAPI.v10InvestorProgramsGet(authorization: authorization,
                                           sorting: sorting,
                                           from: from,
                                           to: to,
                                           chartPointsCount: chartPointsCount,
                                           currencySecondary: currencySecondary,
                                           dashboardActionStatus: dashboardActionStatus,
                                           skip: skip,
                                           take: take) { (programList, error) in
                                            DataProvider().responseHandler(programList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSignalList(with sorting: InvestorAPI.Sorting_v10InvestorSignalsGet? = nil, from: Date? = nil, to: Date? = nil, chartPointsCount: Int? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorSignalsGet? = nil, actionStatus: InvestorAPI.ActionStatus_v10InvestorSignalsGet? = nil, dashboardActionStatus: InvestorAPI.DashboardActionStatus_v10InvestorSignalsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ signalList: SignalsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorSignalsGet(authorization: authorization,
                                           sorting: sorting,
                                           from: from,
                                           to: to,
                                           chartPointsCount: chartPointsCount,
                                           currencySecondary: currencySecondary,
                                           actionStatus: actionStatus,
                                           dashboardActionStatus: dashboardActionStatus,
                                           skip: skip,
                                           take: take) { (signalList, error) in
                                            DataProvider().responseHandler(signalList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getFundList(_ filterModel: FilterModel? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorFundsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programList: FundsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let from = filterModel?.dateRangeModel.dateFrom
        let to = filterModel?.dateRangeModel.dateTo
        
        var dashboardActionStatus: InvestorAPI.DashboardActionStatus_v10InvestorFundsGet = .all
        
        if let onlyActive = filterModel?.onlyActive {
            dashboardActionStatus = onlyActive ? .active : .all
        }
        
        InvestorAPI.v10InvestorFundsGet(authorization: authorization,
                                        sorting: nil,
                                        from: from,
                                        to: to,
                                        chartPointsCount: nil,
                                        currencySecondary: currencySecondary,
                                        dashboardActionStatus: dashboardActionStatus,
                                        skip: skip,
                                        take: take) { (fundList, error) in
                                            DataProvider().responseHandler(fundList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
