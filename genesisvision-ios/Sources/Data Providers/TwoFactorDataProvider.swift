//
//  TwoFactorDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class TwoFactorDataProvider: DataProvider {
    // MARK: - Public methods
    static func auth2faGetStatus(completion: @escaping (_ twoFactorStatus: TwoFactorStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        AuthAPI.v10Auth2faGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func auth2faCreate(completion: @escaping (_ twoFactorAuthenticator: TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        AuthAPI.v10Auth2faCreatePost(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func auth2faConfirm(twoFactorCode: String, sharedKey: String, password: String, completion: @escaping (_ recoveryCodesViewModel: RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        let twoFactorAuthenticatorConfirm = TwoFactorAuthenticatorConfirm(code: twoFactorCode, sharedKey: sharedKey, password: password)
        
        AuthAPI.v10Auth2faConfirmPost(authorization: authorization, model: twoFactorAuthenticatorConfirm) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func auth2faDisable(twoFactorCode: String? = nil, recoveryCode: String? = nil, password: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, let twoFactorCode = twoFactorCode else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let twoFactorCodeModel = TwoFactorCodeModel(twoFactorCode: twoFactorCode, password: password)
        
        AuthAPI.v10Auth2faDisablePost(authorization: authorization, model: twoFactorCodeModel) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}


