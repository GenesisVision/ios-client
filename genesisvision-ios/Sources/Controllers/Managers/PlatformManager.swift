//
//  PlatformManager.swift
//  genesisvision-ios
//
//  Created by George on 11/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class PlatformManager {
    private static var platformStatus: PlatformStatus?
    
    static func getPlatformStatus(completion: @escaping (_ platformStatus: PlatformStatus?) -> Void) {
        BaseDataProvider.getPlatformStatus(completion: { (viewModel) in
            if viewModel != nil  {
                platformStatus = viewModel
            }
            
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
}
