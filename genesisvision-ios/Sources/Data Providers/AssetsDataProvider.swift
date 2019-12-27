//
//  AssetsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class AssetsDataProvider: DataProvider {
    // MARK: - Update Program/Fund/Follow assets
    static func updateAsset(_ assetId: String, model: ProgramUpdate, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateAsset(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Fund
    static func closeFund(_ fundId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: fundId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeFund(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateFundAssets(_ fundId: String, assets: [FundAssetPart], completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: fundId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateFundAssets(id: uuid, authorization: authorization, assets: assets) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createFund(_ request: NewFundRequest?, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.createFund(authorization: authorization, request: request) { (error) in
           DataProvider().responseHandler(error, completion: completion)
       }
    }
    
    // MARK: - Programs
    static func confirmProgram2FA(_ programId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.confirmProgram2FA(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getProgram2FA(_ programId: String, completion: @escaping (TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId), let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.getProgram2FA(id: uuid, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func changeBroker(_ brokerId: String, request: ChangeBrokerProgramRequest?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: brokerId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.changeBroker(id: uuid, authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func cancelChangeBroker(_ brokerId: String, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: brokerId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.cancelChangeBroker(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func closeProgram(_ programId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeInvestmentProgram(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getLevelsCalculator(_ programId: String, completion: @escaping (ProgramLevelInfo??) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId), let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.getLevelsCalculator(id: uuid, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func closeCurrentPeriod(_ programId: String, model: TradingAccountPwdUpdate?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeCurrentPeriod(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func makeAccountProgram(_ request: MakeTradingAccountProgram?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.makeAccountProgram(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func makeSignalProviderProgram(_ request: MakeSignalProviderProgram?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.makeSignalProviderProgram(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Signal
    static func makeAccountSignalProvider(_ request: MakeTradingAccountSignalProvider?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.makeAccountSignalProvider(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateSignalProviderSettings(_ request: CreateSignalProvider?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateSignalProviderSettings(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Trading accounts
    static func changeTradingAccountPassword(_ accountId: String, model: TradingAccountPwdUpdate?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: accountId), let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.changeTradingAccountPassword(id: uuid, authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createTradingAccount(_ request: NewTradingAccountRequest?, completion: @escaping (TradingAccountCreateResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.createTradingAccount(authorization: authorization, request: request) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func createExternalTradingAccount(_ request: NewExternalTradingAccountRequest?, completion: @escaping (TradingAccountCreateResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.createExternalTradingAccount(authorization: authorization, request: request){ (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func makeExternalAccountSignalProvider(_ request: MakeTradingAccountSignalProvider?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.makeExternalAccountSignalProvider(authorization: authorization, request: request) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
}
