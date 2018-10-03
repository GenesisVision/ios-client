//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class DashboardDataProvider: DataProvider {
    static func getProgramList(with sorting: InvestorAPI.Sorting_v10InvestorProgramsGet? = nil, from: Date? = nil, to: Date? = nil, chartPointsCount: Int? = nil, currencySecondary: InvestorAPI.CurrencySecondary_v10InvestorProgramsGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programList: ProgramsList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.v10InvestorProgramsGet(authorization: authorization,
                                           sorting: sorting,
                                           from: from,
                                           to: to,
                                           chartPointsCount: chartPointsCount,
                                           currencySecondary: currencySecondary,
                                           skip: skip,
                                           take: take) { (programList, error) in
                                            DataProvider().responseHandler(programList, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
