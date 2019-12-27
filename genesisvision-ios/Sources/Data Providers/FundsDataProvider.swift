//
//  FundsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 24/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundsDataProvider: DataProvider {
    // MARK: - Assets
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (ItemsViewModelFundDetailsListItem?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let dateFrom = filterModel?.dateRangeModel.dateFrom
        let dateTo = filterModel?.dateRangeModel.dateTo
        
        let sorting = filterModel?.sortingModel.selectedSorting as? FundsAPI.Sorting_getFunds ?? FundsAPI.Sorting_getFunds.byProfitDesc
        
        let assets = filterModel?.tagsModel.selectedTags
        let mask = filterModel?.mask
        let showFavorites = filterModel?.isFavorite
        let facetId = filterModel?.facetId
        var ownerId: UUID?
        if let managedId = filterModel?.managerId {
            ownerId = UUID(uuidString: managedId)
        }
        
        var showIn: FundsAPI.ShowIn_getFunds?
        if let newCurrency = FundsAPI.ShowIn_getFunds(rawValue: selectedPlatformCurrency) {
            showIn = newCurrency
        }
        
        let authorization = AuthManager.authorizedToken
        
        FundsAPI.getFunds(authorization: authorization, sorting: sorting, showIn: showIn, assets: assets, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: nil, facetId: facetId,  mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(_ assetId: String, currencySecondary: FundsAPI.Currency_getFundDetails? = nil, completion: @escaping (FundDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken
        
        FundsAPI.getFundDetails(id: assetId, authorization: authorization, currency: currencySecondary) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Invest & Withdraw
    static func getWithdrawInfo(_ assetId: String, currency: InvestmentsAPI.Currency_getFundWithdrawInfo, completion: @escaping (FundWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getFundWithdrawInfo(id: uuid, authorization: authorization, currency: currency) { (fundWithdrawInfo, error) in
            DataProvider().responseHandler(fundWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func withdraw(withPercent percent: Double, assetId: String?, currency: InvestmentsAPI.Currency_withdrawFromFund?, errorCompletion: @escaping CompletionBlock) {
          guard let authorization = AuthManager.authorizedToken,
              let assetId = assetId,
              let uuid = UUID(uuidString: assetId)
              else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
          
          InvestmentsAPI.withdrawFromFund(id: uuid, authorization: authorization, percent: percent, currency: currency) { (error) in
              DataProvider().responseHandler(error, completion: errorCompletion)
          }
      }
    static func invest(withAmount amount: Double, assetId: String?, walletId: UUID? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.investIntoFund(id: uuid, authorization: authorization, amount: amount, walletId: walletId) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    // MARK: - Charts
    static func getProfitPercentCharts(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: FundsAPI.Currency_getFundProfitPercentCharts? = nil, completion: @escaping (_ tradesChartViewModel: FundProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundProfitPercentCharts(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getAbsoluteProfitChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: FundsAPI.Currency_getFundAbsoluteProfitChart? = nil, completion: @escaping (_ tradesChartViewModel: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundAbsoluteProfitChart(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBalanceChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: FundsAPI.Currency_getFundBalanceChart? = nil, completion: @escaping (_ tradesChartViewModel: FundBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundBalanceChart(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    // MARK: - Reallocate history
    static func getReallocateHistory(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ reallocationsViewModel: ItemsViewModelReallocationModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getReallocatingHistory(id: uuid, dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Favorites
    static func favorites(isFavorite: Bool, assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? favoritesRemove(with: assetId, authorization: authorization, completion: completion)
            : favoritesAdd(with: assetId, authorization: authorization, completion: completion)
    }
    
    private static func favoritesAdd(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.addToFavorites(id: uuid, authorization: authorization) { (error) in
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
        
        FundsAPI.removeFromFavorites(id: uuid, authorization: authorization) { (error) in
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
