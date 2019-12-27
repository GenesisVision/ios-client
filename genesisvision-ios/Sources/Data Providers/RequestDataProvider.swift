//
//  RequestDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class RequestDataProvider: DataProvider {
    static func getAllRequests(skip: Int, take: Int, completion: @escaping (ItemsViewModelAssetInvestmentRequest?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        InvestmentsAPI.getRequests(skip: skip, take: take, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getRequests(with assetId: String, skip: Int, take: Int, completion: @escaping (ItemsViewModelAssetInvestmentRequest?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getRequestsByProgram(id: uuid, skip: skip, take: take, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    static func cancelRequest(requestId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, 
            let uuid = UUID(uuidString: requestId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.cancelRequest(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
