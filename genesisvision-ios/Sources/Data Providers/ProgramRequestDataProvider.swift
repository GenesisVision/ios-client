//
//  ProgramRequestDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramRequestDataProvider: DataProvider {
    static func getRequests(filter: InvestmentProgramRequestsFilter, completion: @escaping (_ programRequests: InvestmentProgramRequests?) -> Void) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        getProgramRequests(with: authorization, filter: filter) { (viewModel) in
            completion(viewModel)
        }
    }
    
    static func cancelRequest(requestId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, 
            let uuid = UUID(uuidString: requestId)
            else { return completion(.failure(reason: nil)) }
        
        cancelRequest(with: authorization, requestId: uuid, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getProgramRequests(with authorization: String, filter: InvestmentProgramRequestsFilter, completion: @escaping (_ programRequests: InvestmentProgramRequests?) -> Void) {
        InvestorAPI.apiInvestorInvestmentProgramRequestsPost(authorization: authorization, filter: filter) { (programRquests, error) in
            DataProvider().responseHandler(programRquests, error: error, successCompletion: { (viewModel) in
                completion(viewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func cancelRequest(with authorization: String, requestId: UUID, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorInvestmentProgramsCancelInvestmentRequestPost(requestId: requestId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
