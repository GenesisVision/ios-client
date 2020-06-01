//
//  UsersDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class UsersDataProvider: DataProvider {
    // MARK: - Details
    static func get(with userId: String, completion: @escaping (PublicProfile?) -> Void, errorCompletion: @escaping CompletionBlock) {
        UsersAPI.getUserProfile(_id: userId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getList(sorting: UsersFilterSorting?, tags: [String]?, skip: Int?, take: Int?, completion: @escaping (UserDetailsListItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        UsersAPI.getUsersList(sorting: sorting, tags: tags, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}



