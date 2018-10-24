//
//  FundsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 24/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundsDataProvider: DataProvider {
    static func get(sorting: FundsAPI.Sorting_v10FundsGet? = nil, currencySecondary: FundsAPI.CurrencySecondary_v10FundsGet? = nil, statisticDateFrom: Date? = nil, statisticDateTo: Date? = nil, chartPointsCount: Int? = nil, mask: String? = nil, facetId: String? = nil, isFavorite: Bool? = nil, ids: [UUID]? = nil, managerId: String? = nil, programManagerId: UUID? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ fundsList: FundsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let authorization = AuthManager.authorizedToken

        FundsAPI.v10FundsGet(authorization: authorization, sorting: sorting, currencySecondary: currencySecondary, statisticDateFrom: statisticDateFrom, statisticDateTo: statisticDateTo, chartPointsCount: chartPointsCount, mask: mask, facetId: facetId, isFavorite: isFavorite, ids: ids, managerId: managerId, programManagerId: programManagerId, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(fundId: String, currencySecondary: FundsAPI.CurrencySecondary_v10FundsByIdGet? = nil, completion: @escaping (_ fundDetailsFull: FundDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken
        
        FundsAPI.v10FundsByIdGet(id: fundId, authorization: authorization, currencySecondary: currencySecondary) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getInvestInfo(programId: String, currencySecondary: InvestorAPI.Currency_v10InvestorFundsByIdInvestInfoByCurrencyGet, completion: @escaping (_ fundInvestInfo: FundInvestInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdInvestInfoByCurrencyGet(id: uuid, currency: currencySecondary, authorization: authorization) { (fundInvestInfo, error) in
            DataProvider().responseHandler(fundInvestInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWithdrawInfo(programId: String, currencySecondary: InvestorAPI.Currency_v10InvestorFundsByIdWithdrawInfoByCurrencyGet, completion: @escaping (_ fundWithdrawInfo: FundWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: programId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdWithdrawInfoByCurrencyGet(id: uuid, currency: currencySecondary, authorization: authorization) { (fundWithdrawInfo, error) in
            DataProvider().responseHandler(fundWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func invest(withAmount amount: Double, fundId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let fundId = fundId,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdInvestByAmountPost(id: uuid, amount: amount, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func withdraw(withPercent percent: Double, fundId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let fundId = fundId,
            let uuid = UUID(uuidString: fundId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorFundsByIdWithdrawByPercentPost(id: uuid, percent: percent, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
}
