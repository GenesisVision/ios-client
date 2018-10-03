//
//  ProgramViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ProgramViewModel {
    // MARK: - Variables
    var programId: String!
    var programDetailsFull: ProgramDetailsFull?
    
    var router: ProgramRouter!
    
    // MARK: - Init
    init(withRouter router: Router, programId: String, programViewController: ProgramViewController) {
        self.programId = programId
        
        self.router = ProgramRouter(parentRouter: router, navigationController: nil, programViewController: programViewController)
    }
    
    func showNotifications() {
        router.show(routeType: .notifications)
    }
}
