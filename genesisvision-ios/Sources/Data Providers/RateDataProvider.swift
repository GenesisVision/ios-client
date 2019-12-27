//
//  RateDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class RateDataProvider: DataProvider {
    // MARK: - Public methods
    static func getRates(from: [String]? = nil, to: [String]? = nil, completion: @escaping (_ ratesModel: RatesModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        RateAPI.getRates(from: from, to: to) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    static func getRate(from: String, to: String, completion: @escaping (_ rate: RateModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        RateAPI.getRate(from: from, to: to) { (rate, error) in
            DataProvider().responseHandler(rate, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
