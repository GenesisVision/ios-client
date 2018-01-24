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
    
    static var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        if let traderListViewController = TraderListViewController.storyboardInstance(name: .traders) {
            viewControllers.append(BaseNavigationController(rootViewController: traderListViewController))
        }
        
        if isInvestorApp, let dashboardViewController = DashboardViewController.storyboardInstance(name: .dashboard) {
            viewControllers.append(BaseNavigationController(rootViewController: dashboardViewController))
        }
        
        if let walletViewController = WalletViewController.storyboardInstance(name: .wallet) {
            viewControllers.append(BaseNavigationController(rootViewController: walletViewController))
        }
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            viewControllers.append(BaseNavigationController(rootViewController: profileViewController))
        }
        
        return viewControllers
    }
    
    static func signInWithTransition() {
        let tabBarController = BaseTabBarController()
        tabBarController.viewControllers = tabBarControllers
        
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = tabBarController
    }
    
    static func signOutWithTransition() {
        AuthController.authorizedToken = nil
        
        guard let viewController = TraderListViewController.storyboardInstance(name: .traders) else { return }
        
        let window = UIApplication.shared.windows[0] as UIWindow
        let navigationController = BaseNavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
    
    
    // MARK: - Common API Methods
    
    static func signIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        isInvestorApp
            ? investorSignIn(email: email, password: password, completion: completion)
            : managerSignIn(email: email, password: password, completion: completion)
    }
    
    static func signUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        isInvestorApp
            ? investorSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
            : managerSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
    
    // MARK: - API Methods
    
    private static func investorSignIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        _ = AccountAPI.apiInvestorAuthSignInPostWithRequestBuilder(model: loginViewModel)
    }
    
    private static func investorSignUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        _ = AccountAPI.apiInvestorAuthSignUpPostWithRequestBuilder(model: registerInvestorViewModel)
    }
    
    private static func managerSignIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        _ = AccountAPI.apiManagerAuthSignInPostWithRequestBuilder(model: loginViewModel)
    }
    
    private static func managerSignUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        let registerManagerViewModel = RegisterManagerViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        let requestBuilder = AccountAPI.apiManagerAuthSignUpPostWithRequestBuilder(model: registerManagerViewModel)
        
        execute(requestBuilder: requestBuilder, completion: completion)
    }
    
    private static func execute(requestBuilder: RequestBuilder<Void>, completion: @escaping ApiCompletionBlock) {
        requestBuilder.execute { (response, error) in
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
                    
                    guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined(separator: "\n") else {
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
