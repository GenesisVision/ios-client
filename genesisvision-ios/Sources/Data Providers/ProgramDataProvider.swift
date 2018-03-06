//
//  ProgramDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDataProvider: DataProvider {
    static func getProgram(investmentProgramId: String, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void) {
        let authorization = AuthManager.authorizedToken
        
        getInvestorProgram(with: investmentProgramId, authorization: authorization) { (viewModel) in
            completion(viewModel)
        }
    }
    
    static func investProgram(withAmount amount: Double, investmentProgramId: String?, completion: @escaping (_ walletsViewModel: WalletsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let investmentProgramId = investmentProgramId,
            let uuid = UUID(uuidString: investmentProgramId)
            else { return errorCompletion(.failure(reason: nil)) }
        
        let investModel = Invest(investmentProgramId: uuid, amount: amount)
        
        InvestorAPI.apiInvestorInvestmentProgramsInvestPost(authorization: authorization, model: investModel) { (walletsViewModel, error) in
            DataProvider().responseHandler(walletsViewModel, error: error, successCompletion: { (viewModel) in
                completion(viewModel)
            }, errorCompletion: { (result) in
                errorCompletion(result)
            })
        }
    }
    
    static func withdrawProgram(withAmount amount: Double, investmentProgramId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let investmentProgramId = investmentProgramId,
            let uuid = UUID(uuidString: investmentProgramId)
            else { return errorCompletion(.failure(reason: nil)) }
        
        let investModel = Invest(investmentProgramId: uuid, amount: amount)

        InvestorAPI.apiInvestorInvestmentProgramsWithdrawPost(authorization: authorization, model: investModel) { (error) in
            DataProvider().responseHandler(error, completion: { (result) in
                errorCompletion(result)
            })
        }
    }
    
    static func getPrograms(with filter: InvestmentProgramsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        let authorization = AuthManager.authorizedToken
        
        isInvestorApp
            ? getInvestorPrograms(with: filter, authorization: authorization) { (viewModel) in
                completion(viewModel)
                }
            : getManagerPrograms(with: filter, authorization: authorization) { (viewModel) in
                completion(viewModel)
        }
    }
    
    // MARK: - Private methods
    private static func getInvestorProgram(with investmentProgramId: String, authorization: String?, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void) {
        guard let uuid = UUID(uuidString: investmentProgramId) else { return completion(nil) }
        
        InvestorAPI.apiInvestorInvestmentProgramGet(investmentProgramId: uuid, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel?.investmentProgram, error: error, successCompletion: { (programViewModel) in
                completion(programViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getInvestorPrograms(with filter: InvestmentProgramsFilter, authorization: String?, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        InvestorAPI.apiInvestorInvestmentProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (programs) in
                completion(programs)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private static func getManagerPrograms(with filter: InvestmentProgramsFilter, authorization: String?, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        ManagerAPI.apiManagerInvestmentProgramsPost(authorization: authorization, filter: filter) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (programs) in
                completion(programs)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}

