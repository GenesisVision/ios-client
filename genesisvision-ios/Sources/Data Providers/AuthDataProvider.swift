//
//  AuthDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class AuthDataProvider: DataProvider {
    // MARK: - Public methods
    static func signIn(email: String, password: String, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        isInvestorApp
            ? investorSignIn(with: loginViewModel, completion: completion, errorCompletion: errorCompletion)
            : managerSignIn(with: loginViewModel, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func signUp(email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        isInvestorApp
            ? investorSignUp(with: email, password: password, confirmPassword: confirmPassword, completion: completion)
            : managerSignUp(with: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
    
    // MARK: - Private methods
    private static func investorSignIn(with model: LoginViewModel, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuthSignInPost(model: model) { (token, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    completion(token)
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    private static func managerSignIn(with model: LoginViewModel, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuthSignInPost(model: model) { (token, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    completion(token)
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    private static func investorSignUp(with email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        InvestorAPI.apiInvestorAuthSignUpPost(model: registerInvestorViewModel) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                completion(result)
            })
        }
    }
    
    private static func managerSignUp(with email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerManagerViewModel = RegisterManagerViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        ManagerAPI.apiManagerAuthSignUpPost(model: registerManagerViewModel) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                completion(result)
            })
        }
    }
}

