//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DashboardDataProvider: DataProvider {
    static func getProgram(with sorting: InvestorAPI.Sorting_apiInvestorDashboardGet, completion: @escaping (_ dashboard: InvestorDashboard?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        getDashboardProgram(with: sorting, authorization: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    // MARK: - Private methods
    private static func getDashboardProgram(with sorting: InvestorAPI.Sorting_apiInvestorDashboardGet, authorization: String, completion: @escaping (_ dashboard: InvestorDashboard?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorDashboardGet(authorization: authorization, sorting: sorting) { (dashboard, error) in
            DataProvider().responseHandler(dashboard, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
