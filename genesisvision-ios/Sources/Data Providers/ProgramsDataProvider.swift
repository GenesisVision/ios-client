//
//  ProgramsDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramsDataProvider: DataProvider {
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programsViewModel: ProgramsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
    
        let levelMin = filterModel?.levelModel.minLevel
        let levelMax = filterModel?.levelModel.maxLevel
        
        let statisticDateFrom = filterModel?.dateRangeModel.dateFrom
        let statisticDateTo = filterModel?.dateRangeModel.dateTo
        
        let sorting = filterModel?.sortingModel.selectedSorting as? ProgramsAPI.Sorting_v10ProgramsGet ?? ProgramsAPI.Sorting_v10ProgramsGet.byProfitDesc
        
        let profitAvgMin = filterModel?.profitAvgMin
        let profitAvgMax = filterModel?.profitAvgMax
        
        let mask = filterModel?.mask
        let isFavorite = filterModel?.isFavorite
        let facetId = filterModel?.facetId
        let managerId = filterModel?.managerId
        let chartPointsCount = filterModel?.chartPointsCount
        let levelUpFrom = filterModel?.levelUpData?.level
        
        var programCurrency: ProgramsAPI.ProgramCurrency_v10ProgramsGet?
        if let selectedCurrency = filterModel?.currencyModel.selectedCurrency, let newCurrency = ProgramsAPI.ProgramCurrency_v10ProgramsGet(rawValue: selectedCurrency) {
            programCurrency = newCurrency
        }
        
        var currencySecondary: ProgramsAPI.CurrencySecondary_v10ProgramsGet?
        if let newCurrency = ProgramsAPI.CurrencySecondary_v10ProgramsGet(rawValue: getSelectedCurrency()) {
            currencySecondary = newCurrency
        }
        
        let authorization = AuthManager.authorizedToken
        
        ProgramsAPI.v10ProgramsGet(authorization: authorization, levelMin: levelMin, levelMax: levelMax, profitAvgMin: profitAvgMin, profitAvgMax: profitAvgMax, sorting: sorting, programCurrency: programCurrency, currencySecondary: currencySecondary, levelUpFrom: levelUpFrom, statisticDateFrom: statisticDateFrom, statisticDateTo: statisticDateTo, chartPointsCount: chartPointsCount, mask: mask, facetId: facetId, isFavorite: isFavorite, ids: nil, managerId: managerId, programManagerId: nil, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getLevelUpSummary(completion: @escaping (_ levelUpSummary: LevelUpSummary?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let authorization = AuthManager.authorizedToken
        
        ProgramsAPI.v10ProgramsLevelupSummaryGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSets(completion: @escaping (_ programSets: ProgramSets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsSetsGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(programId: String, currencySecondary: ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet?, completion: @escaping (_ program: ProgramDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken
        
        ProgramsAPI.v10ProgramsByIdGet(id: programId, authorization: authorization, currencySecondary: currencySecondary) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestInfo(programId: String, currencySecondary: InvestorAPI.Currency_v10InvestorProgramsByIdInvestInfoByCurrencyGet, completion: @escaping (_ programInvestInfo: ProgramInvestInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdInvestInfoByCurrencyGet(id: uuid, currency: currencySecondary, authorization: authorization) { (programInvestInfo, error) in
            DataProvider().responseHandler(programInvestInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWithdrawInfo(programId: String, currencySecondary: InvestorAPI.Currency_v10InvestorProgramsByIdWithdrawInfoByCurrencyGet, completion: @escaping (_ programWithdrawInfo: ProgramWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdWithdrawInfoByCurrencyGet(id: uuid, currency: currencySecondary, authorization: authorization) { (programWithdrawInfo, error) in
            DataProvider().responseHandler(programWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func invest(withAmount amount: Double, programId: String?, currency: InvestorAPI.Currency_v10InvestorProgramsByIdInvestByAmountPost? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let programId = programId,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdInvestByAmountPost(id: uuid, amount: amount, authorization: authorization, currency: currency) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func withdraw(withAmount amount: Double, programId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let programId = programId,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdWithdrawByAmountPost(id: uuid, amount: amount, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func getTradesOpen(with programId: String?, sorting: ProgramsAPI.Sorting_v10ProgramsByIdTradesOpenGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let programId = programId, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdTradesOpenGet(id: uuid, sorting: sorting, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTrades(with programId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: ProgramsAPI.Sorting_v10ProgramsByIdTradesGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let programId = programId, let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdTradesGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getProfitChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ tradesChartViewModel: ProgramProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdChartsProfitGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBalanceChart(with programId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ tradesChartViewModel: ProgramBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdChartsBalanceGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func favorites(isFavorite: Bool, assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? programFavoritesRemove(with: assetId, authorization: authorization, completion: completion)
            : programFavoritesAdd(with: assetId, authorization: authorization, completion: completion)
    }
    
    static func reinvestOn(with programId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdReinvestOnPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func reinvestOff(with programId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        InvestorAPI.v10InvestorProgramsByIdReinvestOffPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getRequests(with programId: String, skip: Int, take: Int, completion: @escaping (_ programRequests: ProgramRequests?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdRequestsBySkipByTakeGet(id: uuid, skip: skip, take: take, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Private methods
    private static func programFavoritesAdd(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdFavoriteAddPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : true, "programId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
    
    private static func programFavoritesRemove(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.v10ProgramsByIdFavoriteRemovePost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : false, "programId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
}

