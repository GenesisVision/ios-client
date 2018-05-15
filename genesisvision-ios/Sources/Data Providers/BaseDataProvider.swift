//
//  BaseDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class BaseDataProvider: DataProvider {
    // MARK: - Public methods
    static func getPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        isInvestorApp
            ? getInvestorPlatformStatus(completion: completion, errorCompletion: errorCompletion)
            : getManagerPlatformStatus(completion: completion, errorCompletion: errorCompletion)
    }
    
    // MARK: - Private methods
    private static func getInvestorPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorPlatformStatusGet { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerPlatformStatusGet { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
