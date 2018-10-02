//
//  ProgramViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ProgramViewModel {
    // MARK: - Variables
    var investmentProgramId: String!
    var investmentProgramDetails: InvestmentProgramDetails?
    
    var router: ProgramRouter!
    
    // MARK: - Init
    init(withRouter router: Router, investmentProgramId: String, programViewController: ProgramViewController) {
        self.investmentProgramId = investmentProgramId
        
        self.router = ProgramRouter(parentRouter: router, navigationController: nil, programViewController: programViewController)
    }
    
    func showNotifications() {
        router.show(routeType: .notifications)
    }
}
