//
//  DataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DataProvider {
    func responseHandler<T>(_ viewModel: T?, error: Error?, successCompletion: @escaping (_ viewModel: T?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            print("Error")
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
}
