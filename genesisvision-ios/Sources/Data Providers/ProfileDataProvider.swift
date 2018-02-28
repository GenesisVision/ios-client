//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider: DataProvider {
    static func getProfileFull(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        guard let token = AuthManager.authorizedToken else { return completion(nil) }
        isInvestorApp
            ? getInvestorProfileFull(with: token) { (viewModel) in
                completion(viewModel)
            }
            : getInvestorProfileFull(with: token) { (viewModel) in
                completion(viewModel)
            }
    }
    
    private static func getInvestorProfileFull(with token: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        InvestorAPI.apiInvestorProfileFullGet(authorization: token) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerProfileFull(with token: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        ManagerAPI.apiManagerProfileFullGet(authorization: token) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}
