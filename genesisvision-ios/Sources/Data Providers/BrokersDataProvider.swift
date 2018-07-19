//
//  BrokersDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 19/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class BrokersDataProvider: DataProvider {
    static func getBrokers(brokerName: String? = nil, tradeServerName: String? = nil, tradeServerType: BrokersFilter.TradeServerType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ brokersViewModel: BrokersViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let filter = BrokersFilter(brokerName: brokerName, tradeServerName: tradeServerName, tradeServerType: tradeServerType, skip: skip, take: take)
        
        getManagerBrokers(filter, completion: completion, errorCompletion: errorCompletion)
    }
    
    // MARK: - Private methods
    private static func getManagerBrokers(_ filter: BrokersFilter?, completion: @escaping (_ brokersViewModel: BrokersViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerBrokersPost(filter: filter) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}

