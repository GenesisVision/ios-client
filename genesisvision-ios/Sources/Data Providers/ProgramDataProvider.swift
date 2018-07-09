//
//  ProgramDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDataProvider: DataProvider {
    static func getProgram(investmentProgramId: String, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken
        
        getInvestorProgram(with: investmentProgramId, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func investProgram(withAmount amount: Double, investmentProgramId: String?, completion: @escaping (_ walletsViewModel: WalletsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let investmentProgramId = investmentProgramId,
            let uuid = UUID(uuidString: investmentProgramId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        let investModel = Invest(investmentProgramId: uuid, amount: amount)
        
        InvestorAPI.apiInvestorInvestmentProgramsInvestPost(authorization: authorization, model: investModel) { (walletsViewModel, error) in
            DataProvider().responseHandler(walletsViewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func withdrawProgram(withAmount amount: Double, investmentProgramId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let investmentProgramId = investmentProgramId,
            let uuid = UUID(uuidString: investmentProgramId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        print(amount)
        let a = amount.rounded(toPlaces: 2)
        print(a)
        let investModel = Invest(investmentProgramId: uuid, amount: amount.rounded(toPlaces: 2))
        print(investModel.amount)
        InvestorAPI.apiInvestorInvestmentProgramsWithdrawPost(authorization: authorization, model: investModel) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    
    static func getPrograms(with filter: InvestmentProgramsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        let authorization = AuthManager.authorizedToken

        isInvestorApp
            ? getInvestorPrograms(with: filter, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
            : getManagerPrograms(with: filter, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getProgramTrades(with filter: TradesFilter, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        isInvestorApp
            ? getInvestorProgramTrades(with: filter, completion: completion, errorCompletion: errorCompletion)
            : getManagerProgramTrades(with: filter, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func getProgramChart(with timeFrame: InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet, investmentProgramId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {

        getInvestorProgramTradesChart(with: timeFrame, investmentProgramId: investmentProgramId, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func programFavorites(isFavorite: Bool, investmentProgramId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? programFavoritesRemove(with: investmentProgramId, authorization: authorization, completion: completion)
            : programFavoritesAdd(with: investmentProgramId, authorization: authorization, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getInvestorProgram(with investmentProgramId: String, authorization: String?, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: investmentProgramId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.apiInvestorInvestmentProgramGet(investmentProgramId: uuid, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel?.investmentProgram, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getInvestorPrograms(with filter: InvestmentProgramsFilter, authorization: String?, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorInvestmentProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerPrograms(with filter: InvestmentProgramsFilter, authorization: String?, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerInvestmentProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    private static func getInvestorProgramTrades(with filter: TradesFilter, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorInvestmentProgramTradesPost(filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerProgramTrades(with filter: TradesFilter, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerInvestmentProgramTradesPost(filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getInvestorProgramTradesChart(with timeFrame: InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet, investmentProgramId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: investmentProgramId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.apiInvestorInvestmentProgramEquityChartGet(investmentProgramId: uuid, timeFrame: timeFrame) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerProgramTradesChart(with timeFrame: ManagerAPI.TimeFrame_apiManagerInvestmentProgramEquityChartGet, investmentProgramId: String, completion: @escaping (_ tradesChartViewModel: TradesChartViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: investmentProgramId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ManagerAPI.apiManagerInvestmentProgramEquityChartGet(investmentProgramId: uuid, timeFrame: timeFrame) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }

    private static func programFavoritesAdd(with investmentProgramId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: investmentProgramId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.apiInvestorInvestmentProgramsFavoritesAddPost(investmentProgramId: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : true, "investmentProgramId" : investmentProgramId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
    
    private static func programFavoritesRemove(with investmentProgramId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: investmentProgramId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.apiInvestorInvestmentProgramsFavoritesRemovePost(investmentProgramId: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : false, "investmentProgramId" : investmentProgramId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
}

