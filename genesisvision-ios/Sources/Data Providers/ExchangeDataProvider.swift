//
//  ExchangeDataProvider.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
class ExchangeDataProvider: DataProvider {
    
    static func getExchanges(completion: @escaping (ExchangeInfoItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ExchangesAPI.getExchanges { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
}
