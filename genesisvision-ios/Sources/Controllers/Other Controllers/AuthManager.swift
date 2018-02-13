//
//  AuthController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIApplication

class AuthManager {
    
    private static var profileViewModel: ProfileFullViewModel?
    
    static var authorizedToken: String? {
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: Constants.UserDefaults.authorizedToken)
        }
        get {
            guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizedToken) else { return nil }
            
            return "Bearer " + token
        }
    }
    
    static func updateToken() {
        AuthManager().updateApiToken { (result) in
            switch result {
            case .success:
                print("Token updated")
            case .failure(let reason):
                print("Token not updated")
                print(reason ?? "Fail with no reason")
            }
        }
    }
    
    static func isLogin() -> Bool {
        return AuthManager.authorizedToken != nil
    }
    
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        guard profileViewModel != nil else {
            getFullProfile(completion: { (viewModel) in
                if viewModel != nil  {
                    profileViewModel = viewModel
                }
                
                completion(viewModel)
            })
            return
        }
        
        completion(profileViewModel)
    }
    
    private static func getFullProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        isInvestorApp
            ? getInvestorProfile(completion: { (viewModel) in
                profileViewModel = viewModel
                completion(profileViewModel)
            })
            : getInvestorProfile(completion: { (viewModel) in
                profileViewModel = viewModel
                completion(profileViewModel)
            })
    }
    
    // MARK: - Private methods
    private static func getInvestorProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        InvestorAPI.apiInvestorProfileFullGet(authorization: authorizedToken ?? "") { (viewModel, error) in
            AuthManager().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        ManagerAPI.apiManagerProfileFullGet(authorization: authorizedToken ?? "") { (viewModel, error) in
            AuthManager().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
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
    
    private func updateApiToken(completion: @escaping CompletionBlock)  {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        InvestorAPI.apiInvestorAuthUpdateTokenGet(authorization: token) { (token, error) in
            guard token != nil else {
                return ErrorHandler.handleApiError(error: error, completion: completion)
            }
            
            AuthManager.authorizedToken = token
            completion(.success)
        }
    }
}
