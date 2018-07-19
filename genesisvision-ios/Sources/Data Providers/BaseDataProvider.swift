//
//  BaseDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseDataProvider: DataProvider {
    // MARK: - Public methods
    static func getPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        isInvestorApp
            ? getInvestorPlatformStatus(completion: completion, errorCompletion: errorCompletion)
            : getManagerPlatformStatus(completion: completion, errorCompletion: errorCompletion)
    }
    
    static func uploadImage(imageURL: URL, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        FilesAPI.apiFilesUploadPost(uploadedFile: imageURL) { (uploadResultModel, error) in
            DataProvider().responseHandler(uploadResultModel, error: error, successCompletion: { (viewModel) in
                let uuid = uploadResultModel?.id?.uuidString
                completion(uuid)
            }, errorCompletion: errorCompletion)
        }
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
