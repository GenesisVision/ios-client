//
//  DataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DataProvider {
    func responseHandler<T>(_ viewModel: T? = nil, error: Error?, successCompletion: @escaping (_ viewModel: T?) -> Void, errorCompletion: @escaping CompletionBlock) {
        networkActivity(show: false)
        
        guard viewModel != nil && error == nil else {
            print("Error")
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        networkActivity(show: false)
        
        guard error == nil else {
            print("Error")
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}
