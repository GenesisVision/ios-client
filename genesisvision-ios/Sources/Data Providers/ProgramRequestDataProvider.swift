//
//  ProgramRequestDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramRequestDataProvider: DataProvider {
    static func getRequests(skip: Int, take: Int, completion: @escaping (_ programRequests: ProgramRequests?) -> Void) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        getProgramRequests(with: authorization, skip: skip, take: take, completion: completion)
    }
    
    static func cancelRequest(requestId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, 
            let uuid = UUID(uuidString: requestId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        cancelRequest(with: authorization, requestId: uuid, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getProgramRequests(with authorization: String, skip: Int, take: Int, completion: @escaping (_ programRequests: ProgramRequests?) -> Void) {
        InvestorAPI.v10InvestorRequestsBySkipByTakeGet(skip: skip, take: take, authorization: authorization) { (programRquests, error) in
            DataProvider().responseHandler(programRquests, error: error, successCompletion: { (viewModel) in
                completion(viewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func cancelRequest(with authorization: String, requestId: UUID, completion: @escaping CompletionBlock) {
        InvestorAPI.v10InvestorProgramsRequestsByIdCancelPost(id: requestId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
