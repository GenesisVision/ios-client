//
//  BaseDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseDataProvider: DataProvider {
    // MARK: - Assets
    static func getPlatformAssetInfo(_ asset: String, completion: @escaping (AssetInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        PlatformAPI.getPlatformAssetInfo(asset: asset) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getAllPlatformAssets(completion: @escaping (PlatformAssets?) -> Void, errorCompletion: @escaping CompletionBlock) {
        PlatformAPI.getAllPlatformAssets { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    // MARK: - Platform
    static func getPlatformInfo(completion: @escaping (PlatformInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        PlatformAPI.getPlatformInfo { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    // MARK: - Levels
    static func getProgramsLevels(_ currencyType: CurrencyType? = nil, completion: @escaping (ProgramsLevelsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        var currency: PlatformAPI.Currency_getProgramLevels?
        
        if let currencyType = currencyType {
            currency = PlatformAPI.Currency_getProgramLevels(rawValue: currencyType.rawValue)
        }
        
        PlatformAPI.getProgramLevels(currency: currency) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getLevelsParameters(_ currency: PlatformAPI.Currency_getProgramLevelsParams? = nil, completion: @escaping (LevelsParamsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        PlatformAPI.getProgramLevelsParams(currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    // MARK: - RiskControl
    static func riskControl(with route: String, client: String? = "iOS", version: String? = nil, completion: @escaping (_ data: CaptchaDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {

        PlatformAPI.getRiskControlInfo(route: route, client: client, version: version) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Files
    static func uploadImage(imageData: Data, imageLocation: ImageLocation?, completion: @escaping (_ uploadResult: UploadResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        FileAPI.uploadFile(uploadedFile: imageData, location: imageLocation) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
