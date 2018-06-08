//
//  AuthDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class AuthDataProvider: DataProvider {
    // MARK: - Public methods
    static func signIn(email: String, password: String, twoFactorCode: String? = nil, recoveryCode: String? = nil, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password, rememberMe: true, twoFactorCode: twoFactorCode, recoveryCode: recoveryCode)
        
        isInvestorApp
            ? investorSignIn(with: loginViewModel, completion: completion, errorCompletion: errorCompletion)
            : managerSignIn(with: loginViewModel, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func signUp(userName: String? = nil, email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        isInvestorApp
            ? investorSignUp(with: email, password: password, confirmPassword: confirmPassword, completion: completion)
            : managerSignUp(with: userName!, email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
    
    static func forgotPassword(email: String, completion: @escaping CompletionBlock) {
        let forgotPasswordViewModel = ForgotPasswordViewModel(email: email)
        
        isInvestorApp
            ? investorForgotPassword(with: forgotPasswordViewModel, completion: completion)
            : managerForgotPassword(with: forgotPasswordViewModel, completion: completion)
    }
    
    static func changePassword(oldPassword: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let changePasswordViewModel = ChangePasswordViewModel(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword)
        
        isInvestorApp
            ? investorChangePassword(with: authorization, model: changePasswordViewModel, completion: completion)
            : managerChangePassword(with: authorization, model: changePasswordViewModel, completion: completion)
    }
    
    // MARK: - Private methods
    // MARK: - Sign In
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
    
    // MARK: - Sign Up
    private static func investorSignUp(with email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        InvestorAPI.apiInvestorAuthSignUpPost(model: registerInvestorViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func managerSignUp(with userName: String, email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerManagerViewModel = RegisterManagerViewModel(userName: userName, email: email, password: password, confirmPassword: confirmPassword)
        
        ManagerAPI.apiManagerAuthSignUpPost(model: registerManagerViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Forgot Password
    private static func investorForgotPassword(with forgotPasswordViewModel: ForgotPasswordViewModel, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuthForgotPasswordPost(model: forgotPasswordViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func managerForgotPassword(with forgotPasswordViewModel: ForgotPasswordViewModel, completion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuthForgotPasswordPost(model: forgotPasswordViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Change Password
    private static func investorChangePassword(with authorization: String, model: ChangePasswordViewModel, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuthChangePasswordPost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func managerChangePassword(with authorization: String, model: ChangePasswordViewModel, completion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuthChangePasswordPost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
}

