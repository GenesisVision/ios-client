//
//  RateDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class RateDataProvider: DataProvider {
    // MARK: - Public methods
    static func getTake(completion: @escaping (_ rateViewModel: RateViewModel?) -> Void) {
        getTake(from: RequestRate.From.gvt, to: RequestRate.To.usd, completion: completion)
    }
    
    static func getTake(from: RequestRate.From, to: RequestRate.To, completion: @escaping (_ rateViewModel: RateViewModel?) -> Void) {
        let requestRate = RequestRate(from: from, to: to)
        
        getTake(with: requestRate) { (viewModel) in
            completion(viewModel)
        }
    }
    
    // MARK: - Private methods
    private static func getTake(with model: RequestRate?, completion: @escaping (_ rateViewModel: RateViewModel?) -> Void) {
        RateAPI.apiRatePost(model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (rateViewModel) in
                completion(rateViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}
