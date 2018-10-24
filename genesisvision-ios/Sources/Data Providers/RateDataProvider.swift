//
//  RateDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class RateDataProvider: DataProvider {
    // MARK: - Public methods
    static func getRates(completion: @escaping (_ ratesModel: RatesModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let from = ["GVT"]
        let to = ["ETH", "BTC", "ADA", "USDT", "XRP", "BCH", "LTC", "DOGE", "USD", "EUR"]
//        let to = ["ETH", "BTC", "ADA", "USD", "EUR"]
        RateAPI.v10RateGet(from: from, to: to) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    static func getRate(from: String, to: String, completion: @escaping (_ rate: Double?) -> Void, errorCompletion: @escaping CompletionBlock) {
        RateAPI.v10RateByFromByToGet(from: from, to: to) { (rate, error) in
            DataProvider().responseHandler(rate, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
