//
//  FollowsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class FollowsDataProvider: DataProvider {
    // MARK: - Assets
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (FollowDetailsListItemItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let tags = filterModel?.tagsModel.selectedTags
        
        let dateFrom = filterModel?.dateRangeModel.dateFrom
        let dateTo = filterModel?.dateRangeModel.dateTo
        
        //let sorting = filterModel?.sortingModel.selectedSorting as? FollowAPI.Sorting_getFollowAssets ?? FollowAPI.Sorting_getFollowAssets.byProfitDesc
        let sorting = filterModel?.sortingModel.selectedSorting as? FollowFilterSorting ?? FollowFilterSorting.byProfitDesc
        
        let mask = filterModel?.mask
        let showFavorites = filterModel?.isFavorite
        
        let facetId = filterModel?.facetId
        var ownerId: UUID?
        if let managedId = filterModel?.managerId {
            ownerId = UUID(uuidString: managedId)
        }
        
        let chartPointsCount = filterModel?.chartPointsCount
        
//        var showIn: Currency?
//        if let newCurrency = Currency(rawValue: selectedPlatformCurrency) {
//            showIn = newCurrency
//        }
        
        FollowAPI.getFollowAssets(sorting: sorting,
                                  showIn: nil,
                                  tags: tags,
                                  dateFrom: dateFrom,
                                  dateTo: dateTo,
                                  chartPointsCount: chartPointsCount,
                                  facetId: facetId,
                                  mask: mask,
                                  ownerId: ownerId,
                                  showFavorites: showFavorites,
                                  skip: skip,
                                  take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func get(_ assetId: String, completion: @escaping (ProgramFollowDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        FollowAPI.getFollowAssetDetails(_id: assetId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Charts
    static func getProfitPercentCharts(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency? = nil, currencies: [Currency]?, completion: @escaping (ProgramProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
                
        FollowAPI.getProfitPercentCharts(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency, currencies: currencies) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getAbsoluteProfitChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency? = nil, completion: @escaping (AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FollowAPI.getAbsoluteProfitChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBalanceChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency? = nil, completion: @escaping (AccountBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FollowAPI.getBalanceChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Subscription
    static func getSubscriptions(with assetId: String, onlyActive: Bool? = nil, completion: @escaping (SignalSubscriptionItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
                
        FollowAPI.getFollowSubscriptionsForAsset(_id: uuid, onlyActive: onlyActive) { (viewModel, error) in
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
        
        FollowAPI.addToFavorites(_id: uuid) { (_, error) in
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
        
        FollowAPI.removeFromFavorites(_id: uuid) { (_, error) in
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
