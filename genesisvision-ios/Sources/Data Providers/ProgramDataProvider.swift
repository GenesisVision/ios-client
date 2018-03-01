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
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        getInvestorProgram(with: investmentProgramId, authorization: authorization) { (viewModel) in
            completion(viewModel)
        }
    }
    
    static func getPrograms(with filter: InvestmentProgramsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
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

