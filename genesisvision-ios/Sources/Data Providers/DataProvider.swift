//
//  DataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DataProvider {
    func responseHandler<T>(_ viewModel: T? = nil, error: Error?, successCompletion: @escaping (_ viewModel: T?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard ReachabilityManager.shared.reachability.connection != .unavailable else {
            return errorCompletion(.failure(errorType: .connectionError(message: String.Alerts.ErrorMessages.noInternetConnection)))
        }
    
        networkActivity(show: false)
        
        guard viewModel != nil && error == nil else {
            print("Error")
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        guard ReachabilityManager.shared.reachability.connection != .unavailable else {
            return completion(.failure(errorType: .connectionError(message: String.Alerts.ErrorMessages.noInternetConnection)))
        }
        
        networkActivity(show: false)
        
        guard error == nil else {
            print("Error")
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}
