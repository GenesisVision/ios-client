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
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateAsset(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func updateFundAssetDetails(_ assetId: String, model: ProgramUpdate, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateAsset_0(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Fund
    static func closeFund(_ fundId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: fundId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeFund(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateFundAssets(_ fundId: String, assets: [FundAssetPart], completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: fundId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.updateFundAssets(_id: uuid, body: assets) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createFund(_ request: NewFundRequest?, completion: @escaping CompletionBlock) {
        
        AssetsAPI.createFund(body: request) { (_, error) in
           DataProvider().responseHandler(error, completion: completion)
       }
    }
    
    // MARK: - Programs
    static func confirmProgram2FA(_ programId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.confirmProgram2FA(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getProgram2FA(_ programId: String, completion: @escaping (TwoFactorAuthenticator?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.getProgram2FA(_id: uuid) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func changeBroker(_ brokerId: String, request: ChangeBrokerProgramRequest?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: brokerId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.changeBroker(_id: uuid, body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func cancelChangeBroker(_ brokerId: String, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: brokerId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.cancelChangeBroker(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func closeProgram(_ programId: String, model: TwoFactorCodeModel?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeInvestmentProgram(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getLevelsCalculator(_ programId: String, completion: @escaping (ProgramLevelInfo??) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.getLevelsCalculator(_id: uuid) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func closeCurrentPeriod(_ programId: String, model: TradingAccountPwdUpdate?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: programId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.closeCurrentPeriod(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func makeAccountProgram(_ request: MakeTradingAccountProgram?, completion: @escaping CompletionBlock) {
                
        AssetsAPI.makeAccountProgram(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func makeSignalProviderProgram(_ request: MakeSignalProviderProgram?, completion: @escaping CompletionBlock) {
                
        AssetsAPI.makeSignalProviderProgram(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Signal
    static func makeAccountSignalProvider(_ request: MakeTradingAccountSignalProvider?, completion: @escaping CompletionBlock) {
                
        AssetsAPI.makeAccountSignalProvider(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateSignalProviderSettings(_ request: CreateSignalProvider?, completion: @escaping CompletionBlock) {
                
        AssetsAPI.updateSignalProviderSettings(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Trading accounts
    static func changeTradingAccountPassword(_ accountId: String, model: TradingAccountPwdUpdate?, completion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: accountId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AssetsAPI.changeTradingAccountPassword(_id: uuid, body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func createTradingAccount(_ request: NewTradingAccountRequest?, completion: @escaping (TradingAccountCreateResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        AssetsAPI.createTradingAccount(body: request) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func createExternalTradingAccount(_ request: NewExternalTradingAccountRequest?, completion: @escaping (TradingAccountCreateResult?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        AssetsAPI.createExternalTradingAccount(body: request){ (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func makeExternalAccountSignalProvider(_ request: MakeTradingAccountSignalProvider?, completion: @escaping CompletionBlock) {
                
        AssetsAPI.makeExternalAccountSignalProvider(body: request) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
}
