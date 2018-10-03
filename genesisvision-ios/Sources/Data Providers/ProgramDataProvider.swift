//
//  ProgramDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDataProvider: DataProvider {
    static func getProgram(programId: String, currencySecondary: ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet?, completion: @escaping (_ program: ProgramDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
//        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdGet(id: programId, authorization: authorization, currencySecondary: currencySecondary) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func createProgram(with newInvestmentRequest: NewInvestmentRequest?, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let newInvestmentRequest = newInvestmentRequest
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ManagerAPI.apiManagerAccountNewInvestmentRequestPost(authorization: authorization, request: newInvestmentRequest) { (uuid, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    completion(uuid?.uuidString)
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    static func investProgram(withAmount amount: Double, programId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let programId = programId,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdInvestByAmountPost(id: uuid, amount: amount, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func withdrawProgram(withAmount amount: Double, programId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let programId = programId,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdWithdrawByAmountPost(id: uuid, amount: amount.rounded(toPlaces: 2), authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func getPrograms(with levelMin: Int? = nil, levelMax: Int? = nil, profitAvgMin: Double? = nil, profitAvgMax: Double? = nil, sorting: ProgramsAPI.Sorting_v10ProgramsGet? = nil, programCurrency: ProgramsAPI.ProgramCurrency_v10ProgramsGet? = nil, currencySecondary: ProgramsAPI.CurrencySecondary_v10ProgramsGet? = nil, statisticDateFrom: Date? = nil, statisticDateTo: Date? = nil, chartPointsCount: Int? = nil, mask: String? = nil, facetId: UUID? = nil, isFavorite: Bool? = nil, ids: [UUID]? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programsViewModel: ProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let authorization = AuthManager.authorizedToken
        
        ProgramsAPI.v10ProgramsGet(authorization: authorization, levelMin: levelMin, levelMax: levelMax, profitAvgMin: profitAvgMin, profitAvgMax: profitAvgMax, sorting: sorting, programCurrency: programCurrency, currencySecondary: currencySecondary, statisticDateFrom: statisticDateFrom, statisticDateTo: statisticDateTo, chartPointsCount: chartPointsCount, mask: mask, facetId: facetId, isFavorite: isFavorite, ids: ids, skip: skip, take: take) { (viewModel, error)
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
        
        isInvestorApp
            ? getInvestorPrograms(with: filter, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
            : getManagerPrograms(with: filter, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getProgramTrades(with programId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: ProgramsAPI.Sorting_v10ProgramsByIdTradesGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let programId = programId, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdTradesGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getProgramChart(with programId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {

//        getInvestorProgramTradesChart(with: timeFrame, programId: programId, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func programFavorites(isFavorite: Bool, programId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? programFavoritesRemove(with: programId, authorization: authorization, completion: completion)
            : programFavoritesAdd(with: programId, authorization: authorization, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getInvestorPrograms(with filter: ProgramsFilter, authorization: String?, completion: @escaping (_ programsViewModel: ProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
//        InvestorAPI.apiInvestorProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
//            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
//        }
    }
    
    private static func getManagerPrograms(with filter: ProgramsFilter, authorization: String?, completion: @escaping (_ programsViewModel: ProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
//        ManagerAPI.apiManagerProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
//            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
//        }
    }
    
    private static func getInvestorProgramTradesChart(with programId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
//        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
//
//        InvestorAPI.apiInvestorProgramEquityChartGet(programId: uuid, timeFrame: timeFrame) { (viewModel, error) in
//            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
//        }
    }
    
    private static func getManagerProgramTradesChart(with timeFrame: ManagerAPI.TimeFrame_apiManagerProgramEquityChartGet, programId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ManagerAPI.apiManagerProgramEquityChartGet(programId: uuid, timeFrame: timeFrame) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    private static func programFavoritesAdd(with programId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdFavoriteAddPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : true, "programId" : programId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
    
    private static func programFavoritesRemove(with programId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdFavoriteRemovePost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : false, "programId" : programId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
}

