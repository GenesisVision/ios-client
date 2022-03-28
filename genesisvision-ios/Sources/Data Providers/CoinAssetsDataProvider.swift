//
//  CoinAssetsDataProvider.swift
//  genesisvision-ios
//
//  Created by Gregory on 15.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation

class CoinAssetsDataProvider: DataProvider {
    static func get(_ sorting: CoinsFilterSorting? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ coinAssetsViewModel: CoinsAssetItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        CoinsAPI.getCoins(sorting: sorting, assets: nil, isFavorite: nil, skip: skip, take: take) { viewModel, error in
                DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getKlines(symbol: String, interval: BinanceKlineInterval? = nil, startTime: Date? = nil, endTime: Date? = nil, limit: Int? = nil, completion: @escaping (_ binanceRawKlineItemsViewModel: BinanceRawKlineItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {

        let fullSymbol = symbol.uppercased() + Currency.usdt.rawValue.uppercased()
        TradingplatformAPI.getKlines(symbol: fullSymbol,
                                     interval: interval,
                                     startTime: startTime,
                                     endTime: endTime,
                                     limit: limit) { viewModel, error in
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
        
        CoinsAPI.addToFavorites(_id: uuid) { (_, error) in
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
    private static func favoritesRemove(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        CoinsAPI.removeFromFavorites(_id: uuid) { (_, error) in
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
