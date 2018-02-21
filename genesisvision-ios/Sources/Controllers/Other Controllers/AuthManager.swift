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
    private static var profileShortViewModel: ProfileShortViewModel?
    
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
    
    static func getBalance(completion: @escaping (_ balance: Double) -> Void) {
        getProfileShort(completion: { (viewModel) in
            if viewModel != nil  {
                profileShortViewModel = viewModel
            }
            
            completion(profileShortViewModel?.balance ?? 0.0)
        })
    }
    
    static func saveProfileShort(viewModel: ProfileShortViewModel) {
        self.profileShortViewModel = viewModel
    }
    
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        guard profileViewModel != nil else {
            ProfileDataProvider.getProfileFull(completion: { (viewModel) in
                if viewModel != nil  {
                    profileViewModel = viewModel
                }
                
                completion(viewModel)
            })
            return
        }
        
        completion(profileViewModel)
    }
    
    static func getProfileShort(completion: @escaping (_ profile: ProfileShortViewModel?) -> Void) {
        guard profileViewModel != nil else {
            ProfileDataProvider.getProfileShort(completion: { (viewModel) in
                if viewModel != nil  {
                    profileShortViewModel = viewModel
                }
                
                completion(viewModel)
            })
            return
        }
        
        completion(profileShortViewModel)
    }
    
    // MARK: - Private methods
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
