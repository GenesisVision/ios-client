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
    
//    var dateRangeFrom: Date = Date().removeDays(7) {
//        didSet {
//            updateTime()
//        }
//    }
//    var dateRangeTo: Date = Date() {
//        didSet {
//            updateTime()
//        }
//    }
    
    var dateFrom: Date?
    var dateTo: Date?
    
    public private(set) var platformInfo: PlatformInfo?
    public private(set) var filterConstants: FilterConstants?
    
    init() {
        filterConstants = getFilterConstants(nil)
    }
    
//    private func updateTime() {
//        dateFrom = dateRangeFrom
//        dateTo = dateRangeTo
//        
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
//        
//        switch dateRangeType {
//        case .custom:
//            dateFrom.setTime(hour: 0, min: 0, sec: 0)
//            dateTo.setTime(hour: 0, min: 0, sec: 0)
//            
//            let hour = calendar.component(.hour, from: dateTo)
//            let min = calendar.component(.minute, from: dateTo)
//            let sec = calendar.component(.second, from: dateTo)
//            dateFrom.setTime(hour: hour, min: min, sec: sec)
//            dateTo.setTime(hour: hour, min: min, sec: sec)
//            dateFrom = dateFrom.removeDays(1)
//        default:
//            let hour = calendar.component(.hour, from: dateTo)
//            let min = calendar.component(.minute, from: dateTo)
//            let sec = calendar.component(.second, from: dateTo)
//            dateFrom.setTime(hour: hour, min: min, sec: sec)
//            dateTo.setTime(hour: hour, min: min, sec: sec)
//        }
//    }
    
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
    
    private func getFilterConstants(_ platformInfo: PlatformInfo?) -> FilterConstants {
        return FilterConstants(minLevel: Constants.Filters.minLevel,
                               maxLevel: Constants.Filters.maxLevel,
                               minAvgProfit: Constants.Filters.minAvgProfit,
                               maxAvgProfit: Constants.Filters.maxAvgProfit,
                               minTotalProfit: Constants.Filters.minTotalProfit,
                               maxTotalProfit: Constants.Filters.maxTotalProfit,
                               minUsdBalance: Constants.Filters.minUsdBalance,
                               maxUsdBalance: Constants.Filters.maxUsdBalance,
                               showActivePrograms: Constants.Filters.showActivePrograms,
                               showMyFavorites: Constants.Filters.showMyFavorites,
                               showAvailableToInvest: Constants.Filters.showAvailableToInvest)
    }
}
