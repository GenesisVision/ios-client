//
//  ProgramDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDataProvider: DataProvider {
    static func getProgram(investmentProgramID: String, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void) {
        getInvestorProgram(with: investmentProgramID) { (viewModel) in
            completion(viewModel)
        }
    }
    
    private static func getInvestorProgram(with investmentProgramID: String, completion: @escaping (_ program: InvestmentProgramDetails?) -> Void) {
        guard let uuid = UUID(uuidString: investmentProgramID) else { return completion(nil) }
        
        InvestorAPI.apiInvestorInvestmentProgramGet(investmentProgramId: uuid) { (viewModel, error) in
            DataProvider().responseHandler(viewModel?.investmentProgram, error: error, successCompletion: { (programViewModel) in
                completion(programViewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}

