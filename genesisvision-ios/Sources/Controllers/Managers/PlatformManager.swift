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
    
    var dateRangeType: DateRangeType = .week
    var dateFrom: Date?
    var dateTo: Date?
    
    public private(set) var platformInfo: PlatformInfo?
    public private(set) var filterConstants: FilterConstants?
    public private(set) var programsLevelsInfo: ProgramsLevelsInfo?
    
    init() {
        filterConstants = getFilterConstants(nil)
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
    
    func getProgramsLevelsInfo(completion: @escaping (_ programsLevelsInfo: ProgramsLevelsInfo?) -> Void) {
        if let programsLevelsInfo = programsLevelsInfo {
            completion(programsLevelsInfo)
        }
        
        BaseDataProvider.getProgramsLevelsInfo(completion: { [weak self] (viewModel) in
            self?.programsLevelsInfo = viewModel
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
