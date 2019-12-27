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
        let model = LoginViewModel(password: password, rememberMe: true, twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, client: client, email: email, captchaCheckResult: captchaCheckResult)
        
        AuthAPI.authorize(model: model) { (token, error) in
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
    
    static func signUp(username: String, email: String, password: String, confirmPassword: String, refCode: String? = nil, isAuto: Bool? = nil, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        
        let model = RegisterViewModel(password: password, confirmPassword: confirmPassword, userName: username, refCode: refCode, isAuto: isAuto, email: email, captchaCheckResult: captchaCheckResult)
        
        AuthAPI.register(model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Password
    static func forgotPassword(email: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        let forgotPasswordViewModel = ForgotPasswordViewModel(email: email, captchaCheckResult: captchaCheckResult)
        
        AuthAPI.forgotPassword(model: forgotPasswordViewModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func changePassword(oldPassword: String, password: String, confirmPassword: String, completion: @escaping (String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let changePasswordViewModel = ChangePasswordViewModel(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword)

        AuthAPI.changePassword(authorization: authorization, model: changePasswordViewModel) { (token, error) in
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
    static func resetPassword(userId: String, code: String, password: String, confirmPassword: String, completion: @escaping (String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        let model = ResetPasswordViewModel(userId: userId, code: code, password: password, confirmPassword: confirmPassword)
        
        AuthAPI.resetPassword(model: model) { (token, error) in
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
}

