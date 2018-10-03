//
//  TournamentListRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentListRouteType {
    case showDetail(programId: String)
}

class TournamentListRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: TournamentListRouteType) {
        switch routeType {
        case .showDetail(let programId):
            showProgramDetails(with: programId)
        }
    }
}

