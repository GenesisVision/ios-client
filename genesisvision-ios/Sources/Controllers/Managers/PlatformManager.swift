//
//  PlatformManager.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

struct FilterConstants {
    var minLevel: Int
    var maxLevel: Int
    
    var minAvgProfit: Double
    var maxAvgProfit: Double
    
    var minTotalProfit: Double
    var maxTotalProfit: Double
    
    var minUsdBalance: Double
    var maxUsdBalance: Double
    
    var showActivePrograms: Bool
    var showMyFavorites: Bool
    var showAvailableToInvest: Bool
    
    var walletModelTypeDefault: TransactionsFilter.ModelType
}

class PlatformManager {
    public private(set) static var platformStatus: PlatformStatus?
    public private(set) static var filterConstants: FilterConstants = {
        return getFilterConstants(nil)
    }()
    
    static func getPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void) {
        BaseDataProvider.getPlatformStatus(completion: { (viewModel) in
            platformStatus = viewModel
            filterConstants = getFilterConstants(platformStatus)
            
            completion(viewModel)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    private static func getFilterConstants(_ platformStatus: PlatformStatus?) -> FilterConstants {
        return FilterConstants(minLevel: Constants.Filters.minLevel,
                               maxLevel: Constants.Filters.maxLevel,
                               minAvgProfit: platformStatus?.programsMinAvgProfit ?? Constants.Filters.minAvgProfit,
                               maxAvgProfit: platformStatus?.programsMaxAvgProfit ?? Constants.Filters.maxAvgProfit,
                               minTotalProfit: platformStatus?.programsMinTotalProfit ?? Constants.Filters.minTotalProfit,
                               maxTotalProfit: platformStatus?.programsMaxTotalProfit ?? Constants.Filters.maxTotalProfit,
                               minUsdBalance: Constants.Filters.minUsdBalance,
                               maxUsdBalance: Constants.Filters.maxUsdBalance,
                               showActivePrograms: Constants.Filters.showActivePrograms,
                               showMyFavorites: Constants.Filters.showMyFavorites,
                               showAvailableToInvest: Constants.Filters.showAvailableToInvest,
                               walletModelTypeDefault: Constants.Filters.walletModelTypeDefault)
    }
}
