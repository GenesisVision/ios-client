//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider {
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
    
    static func getProfileShort(completion: @escaping (_ profile: ProfileShortViewModel?) -> Void) {
        guard let token = AuthManager.authorizedToken else { return completion(nil) }
        
        isInvestorApp
            ? getInvestorProfileShort(with: token) { (viewModel) in
                completion(viewModel)
            }
            : getInvestorProfileShort(with: token) { (viewModel) in
                completion(viewModel)
            }
    }
    
    private static func getInvestorProfileFull(with token: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        InvestorAPI.apiInvestorProfileFullGet(authorization: token) { (viewModel, error) in
            ProfileDataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerProfileFull(with token: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        ManagerAPI.apiManagerProfileFullGet(authorization: token) { (viewModel, error) in
            ProfileDataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getInvestorProfileShort(with token: String, completion: @escaping (_ profile: ProfileShortViewModel?) -> Void) {
        InvestorAPI.apiInvestorProfileGet(authorization: token) { (viewModel, error) in
            ProfileDataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerProfileShort(with token: String, completion: @escaping (_ profile: ProfileShortViewModel?) -> Void) {
        ManagerAPI.apiManagerProfileGet(authorization: token) { (viewModel, error) in
            ProfileDataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private func responseHandler(_ viewModel: ProfileFullViewModel?, error: Error?, successCompletion: @escaping (_ viewModel: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    private func responseHandler(_ viewModel: ProfileShortViewModel?, error: Error?, successCompletion: @escaping (_ viewModel: ProfileShortViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
}
