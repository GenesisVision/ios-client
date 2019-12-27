//
//  TwoFactorDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class TwoFactorDataProvider: DataProvider {
    // MARK: - Public methods
    static func getStatus(completion: @escaping (_ twoFactorStatus: TwoFactorStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        AuthAPI.getTwoStepAuthStatus(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func create(completion: @escaping (_ twoFactorAuthenticator: TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        AuthAPI.createTwoStepAuth(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func confirm(twoFactorCode: String, sharedKey: String, password: String, completion: @escaping (_ recoveryCodesViewModel: RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        let twoFactorAuthenticatorConfirm = TwoFactorAuthenticatorConfirm(code: twoFactorCode, sharedKey: sharedKey, password: password)
        
        AuthAPI.confirmTwoStepAuth(authorization: authorization, model: twoFactorAuthenticatorConfirm) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func disable(twoFactorCode: String? = nil, recoveryCode: String? = nil, password: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, let twoFactorCode = twoFactorCode else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let twoFactorCodeModel = TwoFactorCodeWithPassword(twoFactorCode: twoFactorCode, password: password)
        
        AuthAPI.disableTwoStepAuth(authorization: authorization, model: twoFactorCodeModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Recovery Codes
    static func getRecoveryCodes(_ password: String, completion: @escaping (RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let model = PasswordModel(password: password)
        
        AuthAPI.getTwoStepAuthRecoveryCodes(authorization: authorization, model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func createRecoveryCodes(_ password: String, completion: @escaping (RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let model = PasswordModel(password: password)
        
        AuthAPI.createTwoStepAuthRecoveryCodes(authorization: authorization, model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}


