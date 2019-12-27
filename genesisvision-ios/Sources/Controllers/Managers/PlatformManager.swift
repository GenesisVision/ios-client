//
//  PlatformManager.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

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
}

class PlatformManager {
    static let shared = PlatformManager()
    
    var dateRangeType: DateRangeType = .month
    var dateFrom: Date?
    var dateTo: Date?
    
    public private(set) var platformInfo: PlatformInfo?
    public private(set) var filterConstants: FilterConstants?
    public private(set) var programsLevelsInfo: ProgramsLevelsInfo?
    public private(set) var levelsParamsInfo: LevelsParamsInfo?
    public private(set) var platformAssets: PlatformAssets?
    
    init() {
        filterConstants = getFilterConstants(nil)
    }
    
    func getPlatformAssets(completion: @escaping (_ platformAssets: PlatformAssets?) -> Void) {
        if let platformAssets = platformAssets {
            completion(platformAssets)
        }
        
        BaseDataProvider.getAllPlatformAssets(completion: { [weak self] (viewModel) in
            self?.platformAssets = viewModel
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
    
    func getLevelsParamsInfo(completion: @escaping (_ platformAssets: LevelsParamsInfo?) -> Void) {
        if let levelsParamsInfo = levelsParamsInfo {
            completion(levelsParamsInfo)
        }
        
        BaseDataProvider.getLevelsParameters(completion: { [weak self] (viewModel) in
            self?.levelsParamsInfo = viewModel
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
    
    func getPlatformInfo(completion: @escaping (_ platformInfo: PlatformInfo?) -> Void) {
        if let platformInfo = platformInfo {
            completion(platformInfo)
        }
        
        BaseDataProvider.getPlatformInfo(completion: { [weak self] (viewModel) in
            self?.platformInfo = viewModel
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
    
    func getProgramsLevelsInfo(_ currency: CurrencyType? = nil, completion: @escaping (_ programsLevelsInfo: ProgramsLevelsInfo?) -> Void) {
        if let programsLevelsInfo = programsLevelsInfo {
            completion(programsLevelsInfo)
        }

        BaseDataProvider.getProgramsLevels(currency, completion: { [weak self] (model) in
            self?.programsLevelsInfo = model
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    private func getFilterConstants(_ platformInfo: PlatformInfo?) -> FilterConstants {
        return FilterConstants(minLevel: Filters.minLevel,
                               maxLevel: Filters.maxLevel,
                               minAvgProfit: Filters.minAvgProfit,
                               maxAvgProfit: Filters.maxAvgProfit,
                               minTotalProfit: Filters.minTotalProfit,
                               maxTotalProfit: Filters.maxTotalProfit,
                               minUsdBalance: Filters.minUsdBalance,
                               maxUsdBalance: Filters.maxUsdBalance,
                               showActivePrograms: Filters.showActivePrograms,
                               showMyFavorites: Filters.showMyFavorites,
                               showAvailableToInvest: Filters.showAvailableToInvest)
    }
}
