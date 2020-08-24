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
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (FundDetailsListItemItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let dateFrom = filterModel?.dateRangeModel.dateFrom
        let dateTo = filterModel?.dateRangeModel.dateTo
        
        let sorting = filterModel?.sortingModel.selectedSorting as? FundsFilterSorting ?? FundsFilterSorting.byProfitDesc
        
        let assets = filterModel?.tagsModel.selectedTags
        let mask = filterModel?.mask
        let showFavorites = filterModel?.isFavorite
        let facetId = filterModel?.facetId
        var ownerId: UUID?
        if let managedId = filterModel?.managerId {
            ownerId = UUID(uuidString: managedId)
        }
        
        var showIn: Currency?
        if let newCurrency = Currency(rawValue: selectedPlatformCurrency) {
            showIn = newCurrency
        }
                
        FundsAPI.getFunds(sorting: sorting, showIn: showIn, assets: assets, dateFrom: dateFrom, dateTo: dateTo, chartPointsCount: nil, facetId: facetId,  mask: mask, ownerId: ownerId, showFavorites: showFavorites, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(_ assetId: String, currencyType: Currency? = nil, completion: @escaping (FundDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        FundsAPI.getFundDetails(_id: assetId, currency: currencyType) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getWeeklyWinner(completion: @escaping (FundDetailsListItem?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        FundsAPI.getLastChallengeWinner { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Invest & Withdraw
    static func getWithdrawInfo(_ assetId: String, currency: Currency, completion: @escaping (FundWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getFundWithdrawInfo(_id: uuid, currency: currency) { (fundWithdrawInfo, error) in
            DataProvider().responseHandler(fundWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func withdraw(withPercent percent: Double, assetId: String?, currency: Currency?, errorCompletion: @escaping CompletionBlock) {
          guard let assetId = assetId,
              let uuid = UUID(uuidString: assetId)
              else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
          
          InvestmentsAPI.withdrawFromFund(_id: uuid, percent: percent, currency: currency) { (_, error) in
              DataProvider().responseHandler(error, completion: errorCompletion)
          }
      }
    static func invest(withAmount amount: Double, assetId: String?, walletId: UUID? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.investIntoFund(_id: uuid, amount: amount, walletId: walletId) { (_, error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    // MARK: - Charts
    static func getProfitPercentCharts(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: Currency, currencies: [Currency], completion: @escaping (_ tradesChartViewModel: FundProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundProfitPercentCharts(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currencyType, currencies: currencies) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getAbsoluteProfitChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currencyType: Currency, completion: @escaping (_ tradesChartViewModel: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundAbsoluteProfitChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currencyType) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBalanceChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency, completion: @escaping (_ tradesChartViewModel: FundBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getFundBalanceChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    // MARK: - Reallocate history
    static func getReallocateHistory(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ reallocationsViewModel: ReallocationModelItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FundsAPI.getReallocatingHistory(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take) { (viewModel, error) in
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
        
        FundsAPI.addToFavorites(_id: uuid) { (_, error) in
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
        
        FundsAPI.removeFromFavorites(_id: uuid) { (_, error) in
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
