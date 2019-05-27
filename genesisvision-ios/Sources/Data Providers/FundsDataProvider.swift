//
//  FundsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 24/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundsDataProvider: DataProvider {
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ fundsList: FundsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let statisticDateFrom = filterModel?.dateRangeModel.dateFrom
        let statisticDateTo = filterModel?.dateRangeModel.dateTo
        
        let sorting = filterModel?.sortingModel.selectedSorting as? FundsAPI.Sorting_v10FundsGet ?? FundsAPI.Sorting_v10FundsGet.byProfitDesc
        
        let mask = filterModel?.mask
        let isFavorite = filterModel?.isFavorite
        let facetId = filterModel?.facetId
        let managerId = filterModel?.managerId
//        let chartPointsCount = filterModel?.chartPointsCount
        
        var currencySecondary: FundsAPI.CurrencySecondary_v10FundsGet?
        if let newCurrency = FundsAPI.CurrencySecondary_v10FundsGet(rawValue: getSelectedCurrency()) {
            currencySecondary = newCurrency
        }
        
        let authorization = AuthManager.authorizedToken

        FundsAPI.v10FundsGet(authorization: authorization, sorting: sorting, currencySecondary: currencySecondary, statisticDateFrom: statisticDateFrom, statisticDateTo: statisticDateTo, chartPointsCount: nil, mask: mask, facetId: facetId, isFavorite: isFavorite, ids: nil, managerId: managerId, programManagerId: nil, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSets(completion: @escaping (_ programSets: FundSets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsSetsGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(fundId: String, currencySecondary: FundsAPI.CurrencySecondary_v10FundsByIdGet? = nil, completion: @escaping (_ fundDetailsFull: FundDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken
        
        FundsAPI.v10FundsByIdGet(id: fundId, authorization: authorization, currencySecondary: currencySecondary) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getAssets(fundId: String, completion: @escaping (_ fundAssetsListInfo: FundAssetsListInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsByIdAssetsGet(id: uuid) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestInfo(fundId: String, currencySecondary: InvestorAPI.Currency_v10InvestorFundsByIdInvestInfoByCurrencyGet, completion: @escaping (_ fundInvestInfo: FundInvestInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdInvestInfoByCurrencyGet(id: uuid, currency: currencySecondary, authorization: authorization) { (fundInvestInfo, error) in
            DataProvider().responseHandler(fundInvestInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWithdrawInfo(fundId: String, currency: InvestorAPI.Currency_v10InvestorFundsByIdWithdrawInfoByCurrencyGet, completion: @escaping (_ fundWithdrawInfo: FundWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdWithdrawInfoByCurrencyGet(id: uuid, currency: currency, authorization: authorization) { (fundWithdrawInfo, error) in
            DataProvider().responseHandler(fundWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func invest(withAmount amount: Double, fundId: String?, currency: InvestorAPI.Currency_v10InvestorFundsByIdInvestByAmountPost? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let fundId = fundId,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdInvestByAmountPost(id: uuid, amount: amount, authorization: authorization, currency: currency) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func withdraw(withPercent percent: Double, fundId: String?, currency: InvestorAPI.Currency_v10InvestorFundsByIdWithdrawByPercentPost?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let fundId = fundId,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdWithdrawByPercentPost(id: uuid, percent: percent, authorization: authorization, currency: currency) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func getProfitChart(with fundId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ tradesChartViewModel: FundProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: fundId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsByIdChartsProfitGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBalanceChart(with fundId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ tradesChartViewModel: FundBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: fundId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsByIdChartsBalanceGet(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func favorites(isFavorite: Bool, assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? favoritesRemove(with: assetId, authorization: authorization, completion: completion)
            : favoritesAdd(with: assetId, authorization: authorization, completion: completion)
    }
    
    static func getRequests(with fundId: String, skip: Int, take: Int, completion: @escaping (_ programRequests: ProgramRequests?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: fundId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsByIdRequestsBySkipByTakeGet(id: uuid, skip: skip, take: take, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Private methods
    private static func favoritesAdd(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsByIdFavoriteAddPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .fundFavoriteStateChange, object: nil, userInfo: ["isFavorite" : true, "fundId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
    
    private static func favoritesRemove(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.v10FundsByIdFavoriteRemovePost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .fundFavoriteStateChange, object: nil, userInfo: ["isFavorite" : false, "fundId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }

}
