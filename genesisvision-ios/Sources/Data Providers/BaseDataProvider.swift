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
    static func getPlatformInfo(completion: @escaping (_ platformStatus: PlatformInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        PlatformAPI.v10PlatformInfoGet { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func uploadImage(imageURL: URL, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        FileAPI.v10FileUploadPost(uploadedFile: imageURL) { (uploadResultModel, error) in
            DataProvider().responseHandler(uploadResultModel, error: error, successCompletion: { (viewModel) in
                let uuid = uploadResultModel?.id?.uuidString
                completion(uuid)
            }, errorCompletion: errorCompletion)
        }
    }
}
