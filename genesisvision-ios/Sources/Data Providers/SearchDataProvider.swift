//
//  SearchDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class SearchDataProvider: DataProvider {
    static func get(_ mask: String? = nil, take: Int? = nil, completion: @escaping (_ searchViewModel: SearchViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        SearchAPI.v10SearchGet(mask: mask, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
