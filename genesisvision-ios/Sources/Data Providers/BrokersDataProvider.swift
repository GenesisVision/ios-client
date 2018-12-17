//
//  BrokersDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 19/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class BrokersDataProvider: DataProvider {
    static func getBrokers(completion: @escaping (_ brokersInfo: BrokersInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        BrokersAPI.v10BrokersGet { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}

