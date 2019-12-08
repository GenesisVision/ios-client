//
//  AuthDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class AuthDataProvider: DataProvider {
    // MARK: - Public methods
    static func signIn(email: String, password: String, twoFactorCode: String? = nil, recoveryCode: String? = nil, client: String? = "iOS", captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let loginViewModel = LoginViewModel(password: password, rememberMe: true, twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, client: client, email: email, captchaCheckResult: captchaCheckResult)
        
        investorSignIn(with: loginViewModel, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func signUp(username: String, email: String, password: String, confirmPassword: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        
        investorSignUp(with: email, password: password, confirmPassword: confirmPassword, captchaCheckResult: captchaCheckResult, completion: completion)
    }
    
    static func forgotPassword(email: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        let forgotPasswordViewModel = ForgotPasswordViewModel(email: email, captchaCheckResult: captchaCheckResult)
        
        investorForgotPassword(with: forgotPasswordViewModel, completion: completion)
    }
    
    static func changePassword(oldPassword: String, password: String, confirmPassword: String, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let changePasswordViewModel = ChangePasswordViewModel(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword)
        AuthAPI.v10AuthPasswordChangePost(authorization: authorization, model: changePasswordViewModel) { (token, error) in
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
    
    // MARK: - Private methods
    // MARK: - Sign In
    private static func investorSignIn(with model: LoginViewModel, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        AuthAPI.v10AuthSigninInvestorPost(model: model) { (token, error) in
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
    private static func investorSignUp(with email: String, password: String, confirmPassword: String, refCode: String? = nil, isAuto: Bool? = nil, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        
        let registerInvestorViewModel = RegisterInvestorViewModel(password: password, confirmPassword: confirmPassword, refCode: refCode, isAuto: isAuto, email: email, captchaCheckResult: captchaCheckResult)

        AuthAPI.v10AuthSignupInvestorPost(model: registerInvestorViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Forgot Password
    private static func investorForgotPassword(with forgotPasswordViewModel: ForgotPasswordViewModel, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        AuthAPI.v10AuthPasswordForgotInvestorPost(model: forgotPasswordViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}

