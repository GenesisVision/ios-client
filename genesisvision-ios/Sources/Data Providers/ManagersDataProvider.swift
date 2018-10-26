//
//  ManagersDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ManagersDataProvider: DataProvider {
    static func getManagerProfile(managerId: String, completion: @escaping (_ managerProfile: ManagerProfile?) -> Void, errorCompletion: @escaping CompletionBlock) {

        ManagerAPI.v10ManagerByIdGet(id: managerId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getManagerProfileDetails(managerId: String, completion: @escaping (_ managerProfileDetails: ManagerProfileDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {

        ManagerAPI.v10ManagerByIdDetailsGet(id: managerId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
