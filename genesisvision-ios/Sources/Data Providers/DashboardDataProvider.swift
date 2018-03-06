//
//  DashboardDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DashboardDataProvider: DataProvider {
    static func getProgram(completion: @escaping (_ dashboard: InvestorDashboard?) -> Void) {
        guard let authorization = AuthManager.authorizedToken else { return completion(nil) }
        
        getDashboardProgram(with: authorization) { (viewModel) in
            completion(viewModel)
        }
    }
    
    // MARK: - Private methods
    private static func getDashboardProgram(with authorization: String, completion: @escaping (_ dashboard: InvestorDashboard?) -> Void) {

        InvestorAPI.apiInvestorDashboardGet(authorization: authorization) { (dashboard, error) in
            DataProvider().responseHandler(dashboard, error: error, successCompletion: { (viewModel) in
                completion(viewModel)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
}
