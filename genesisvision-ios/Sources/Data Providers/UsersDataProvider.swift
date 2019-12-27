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

        UsersAPI.getManagerProfile(id: userId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getList(facetId: String?, sorting: UsersAPI.Sorting_getUsersList?, tags: [String]?, skip: Int?, take: Int?, completion: @escaping (ItemsViewModelUserDetailsList?) -> Void, errorCompletion: @escaping CompletionBlock) {

        UsersAPI.getUsersList(facetId: facetId, sorting: sorting, tags: tags, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}



