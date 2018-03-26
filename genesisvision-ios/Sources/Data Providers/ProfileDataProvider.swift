//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider: DataProvider {
    static func getProfileFull(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        isInvestorApp
            ? getInvestorProfileFull(with: authorization) { (viewModel) in
                completion(viewModel)
            }
            : getInvestorProfileFull(with: authorization) { (viewModel) in
                completion(viewModel)
            }
    }
    
    static func updateProfileImage() {
        
    }
    
    static func updateProfile(model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        isInvestorApp
            ? updateInvestorProfile(with: authorization, model: model, completion: completion)
            : updateManagerProfile(with: authorization, model: model, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getInvestorProfileFull(with authorization: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        InvestorAPI.apiInvestorProfileFullGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerProfileFull(with authorization: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        ManagerAPI.apiManagerProfileFullGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func updateInvestorProfile(with authorization: String, model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorProfileUpdatePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func updateManagerProfile(with authorization: String, model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerProfileUpdatePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
