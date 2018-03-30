//
//  RateDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class RateDataProvider: DataProvider {
    // MARK: - Public methods
    static func getTake(completion: @escaping (_ rateViewModel: RateViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        getTake(from: RequestRate.From.gvt, to: RequestRate.To.usd, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getTake(from: RequestRate.From, to: RequestRate.To, completion: @escaping (_ rateViewModel: RateViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let requestRate = RequestRate(from: from, to: to)
        
        getTake(with: requestRate, completion: completion, errorCompletion: errorCompletion)
    }
    
    // MARK: - Private methods
    private static func getTake(with model: RequestRate?, completion: @escaping (_ rateViewModel: RateViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        RateAPI.apiRatePost(model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
