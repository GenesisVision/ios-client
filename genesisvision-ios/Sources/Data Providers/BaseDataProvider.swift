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
    
    static func getProgramsLevelsInfo(completion: @escaping (_ programsLevelsInfo: ProgramsLevelsInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        PlatformAPI.v10PlatformLevelsGet { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func uploadImage(imageURL: URL, completion: @escaping (_ uploadResult: UploadResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        FileAPI.v10FileUploadPost(uploadedFile: imageURL, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
