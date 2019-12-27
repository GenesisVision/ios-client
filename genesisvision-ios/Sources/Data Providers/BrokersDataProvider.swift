//
//  BrokersDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 19/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BrokersDataProvider: DataProvider {
    static func getBrokers(completion: @escaping (_ brokersInfo: BrokersInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        BrokersAPI.getBrokers { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBrokersExternal(completion: @escaping (_ brokersInfo: BrokersInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        BrokersAPI.getBrokersExternal { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getBrokersForProgram(programId: String, completion: @escaping (_ brokersInfo: BrokersProgramInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        BrokersAPI.getBrokersForProgram(programId: uuid) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}

