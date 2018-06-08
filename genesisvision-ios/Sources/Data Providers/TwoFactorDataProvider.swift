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

        isInvestorApp
            ? investorAuth2faGetStatus(with: authorization, completion: completion, errorCompletion: errorCompletion)
            : managerAuth2faGetStatus(with: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func auth2faCreate(completion: @escaping (_ twoFactorAuthenticator: TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        isInvestorApp
            ? investorAuth2faCreate(with: authorization, completion: completion, errorCompletion: errorCompletion)
            : managerAuth2faCreate(with: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func auth2faConfirm(twoFactorCode: String, sharedKey: String, password: String, completion: @escaping (_ recoveryCodesViewModel: RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }

        let twoFactorAuthenticatorConfirm = TwoFactorAuthenticatorConfirm(code: twoFactorCode, sharedKey: sharedKey, password: password)
        
        isInvestorApp
            ? investorAuth2faConfirm(with: authorization, model: twoFactorAuthenticatorConfirm, completion: completion, errorCompletion: errorCompletion)
            : managerAuth2faConfirm(with: authorization, model: twoFactorAuthenticatorConfirm, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func auth2faDisable(twoFactorCode: String? = nil, recoveryCode: String? = nil, password: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken, let twoFactorCode = twoFactorCode else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let twoFactorCodeModel = TwoFactorCodeModel(twoFactorCode: twoFactorCode, password: password)
        
        isInvestorApp
            ? investorAuth2faDisable(with: authorization, model: twoFactorCodeModel, completion: completion)
            : managerAuth2faDisable(with: authorization, model: twoFactorCodeModel, completion: completion)
    }
    
    // MARK: - Private methods
    // MARK: - Get
    private static func investorAuth2faGetStatus(with authorization: String, completion: @escaping (_ twoFactorStatus: TwoFactorStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuth2faGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func managerAuth2faGetStatus(with authorization: String, completion: @escaping (_ twoFactorStatus: TwoFactorStatus?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuth2faGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Create
    private static func investorAuth2faCreate(with authorization: String, completion: @escaping (_ twoFactorAuthenticator: TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuth2faCreatePost(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func managerAuth2faCreate(with authorization: String, completion: @escaping (_ twoFactorAuthenticator: TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuth2faCreatePost(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Confirm
    private static func investorAuth2faConfirm(with authorization: String, model: TwoFactorAuthenticatorConfirm, completion: @escaping (_ recoveryCodesViewModel: RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuth2faConfirmPost(authorization: authorization, model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func managerAuth2faConfirm(with authorization: String, model: TwoFactorAuthenticatorConfirm, completion: @escaping (_ recoveryCodesViewModel: RecoveryCodesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuth2faConfirmPost(authorization: authorization, model: model) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Disable
    private static func investorAuth2faDisable(with authorization: String, model: TwoFactorCodeModel, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorAuth2faDisablePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func managerAuth2faDisable(with authorization: String, model: TwoFactorCodeModel, completion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerAuth2faDisablePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}


