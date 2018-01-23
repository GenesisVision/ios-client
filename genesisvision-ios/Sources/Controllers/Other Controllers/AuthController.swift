//
//  AuthController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIApplication

class AuthController {
    
    static func setCurrentProfile(_ profileObject: ProfileObject) {
        realmWrite {
            let currentProfile: ProfileEntity = ProfileEntity()
            
            currentProfile.firstName = profileObject.firstName
            currentProfile.lastName = profileObject.lastName
            currentProfile.middleName = profileObject.middleName
            currentProfile.avatar = profileObject.avatar ?? ""
            currentProfile.email = profileObject.email ?? ""
            currentProfile.phone = profileObject.phone
        }
    }
    
    static var authorizedToken: String? {
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: Constants.UserDefaults.authorizedToken)
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizedToken)
        }
    }
    
    static func isLogin() -> Bool {
        return AuthController.authorizedToken != nil
    }
    
    // MARK: - Navigation
    
    static func signInWithTransition() {
        guard let viewController = BaseTabBarController.storyboardInstance(name: .main) else { return }
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
    
    static func signOutWithTransition() {
        AuthController.authorizedToken = nil
        
        guard let viewController = TraderListViewController.storyboardInstance(name: .traders) else { return }
        let window = UIApplication.shared.windows[0] as UIWindow
        let navigationController = BaseNavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
    
    
    // MARK: - API Methods
    
    static func signIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)

        AccountAPI.apiInvestorAuthSignInPostWithRequestBuilder(model: loginViewModel).execute { (response, error) in
            guard response != nil && response?.statusCode == 200 else {
                guard let err = error as? ErrorResponse else {
                    completion(ApiCompletionResult.failure(reason: nil))
                    return
                }
                
                switch err {
                case .error(let code, let data, let properties):
                    print("API ERROR with \(code) code\n Properties: \(properties)")
                    
                    guard let jsonData = data else {
                        completion(ApiCompletionResult.failure(reason: nil))
                        return
                    }
                    
                    var errorViewModel: ErrorViewModel?
                    
                    do {
                        errorViewModel = try JSONDecoder().decode(ErrorViewModel.self, from: jsonData)
                    } catch {}
                    
                    guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined() else {
                        completion(ApiCompletionResult.failure(reason: nil))
                        return
                    }
                    
                    print("API ERROR text \(errorsText)")
                    completion(ApiCompletionResult.failure(reason: errorsText))
                    break
                }
                
                return
            }
            
            //save token
            if let token = response?.body {
                AuthController.authorizedToken = token
            }
            
            completion(ApiCompletionResult.success)
        }
    }
    
    static func signUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        AccountAPI.apiInvestorAuthSignUpPostWithRequestBuilder(model: registerInvestorViewModel).execute { (response, error) in
            guard response != nil && response?.statusCode == 200 else {
                guard let err = error as? ErrorResponse else {
                    completion(ApiCompletionResult.failure(reason: nil))
                    return
                }
                
                switch err {
                case .error(let code, let data, let properties):
                    print("API ERROR with \(code) code\n Properties: \(properties)")
                    
                    guard let jsonData = data else {
                        completion(ApiCompletionResult.failure(reason: nil))
                        return
                    }
                    
                    
                    var errorViewModel: ErrorViewModel?
                    
                    do {
                        errorViewModel = try JSONDecoder().decode(ErrorViewModel.self, from: jsonData)
                    } catch {}
                    
                    guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined() else {
                        completion(ApiCompletionResult.failure(reason: nil))
                        return
                    }
                    
                    print("API ERROR text \(errorsText)")
                    completion(ApiCompletionResult.failure(reason: errorsText))
                }
                
                return
            }
            
            completion(ApiCompletionResult.success)
        }
    }
}
