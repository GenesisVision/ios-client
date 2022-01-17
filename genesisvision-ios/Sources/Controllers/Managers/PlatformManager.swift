//
//  PlatformManager.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import IdensicMobileSDK

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
    
    var dateRangeType: DateRangeType = .all
    var dateFrom: Date?
    var dateTo: Date?
    
    public private(set) var sdkInstance: SNSMobileSDK?
    public private(set) var platformInfo: PlatformInfo?
    public private(set) var filterConstants: FilterConstants?
    public private(set) var programsLevelsInfo: ProgramsLevelsInfo?
    public private(set) var levelsParamsInfo: LevelsParamsInfo?
    public private(set) var platformAssets: PlatformAssets?
    
    init() {
        filterConstants = getFilterConstants(nil)
    }
    
    func getPlatformAssets(completion: @escaping (_ platformAssets: PlatformAssets?) -> Void) {
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
    
    func getKYCViewController(token: String, baseUrl: String, flowName: String, oneMoreVC: UIViewController? = nil) -> UIViewController? {
        sdkInstance = SNSMobileSDK(baseUrl: baseUrl, flowName: flowName, accessToken: token, locale: Locale.current.identifier, supportEmail: "")
//        sdkInstance = SNSMobileSDK(accessToken: token)
        
        guard let isReady = sdkInstance?.isReady, isReady else {
            return nil
        }
        
        guard let mainKYCViewController = sdkInstance?.mainVC else { return nil }
        
        if let viewController = oneMoreVC {
            mainKYCViewController.pushViewController(viewController, animated: false)
        }
        
        return mainKYCViewController
    }
    
    func getLevelsParamsInfo(currency: Currency, completion: @escaping (_ platformAssets: LevelsParamsInfo?) -> Void) {
        BaseDataProvider.getLevelsParameters(currency, completion: { [weak self] (viewModel) in
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
        BaseDataProvider.getProgramsLevels(currency, completion: { [weak self] (model) in
            self?.programsLevelsInfo = model
            completion(self?.programsLevelsInfo)
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
