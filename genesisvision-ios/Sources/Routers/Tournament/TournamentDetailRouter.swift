//
//  TournamentDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentDetailRouteType {
    case invest
}

class TournamentDetailRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: TournamentDetailRouteType) {
        switch routeType {
        case .invest:
            invest()
        }
    }
    
    // MARK: - Private methods
    private func invest() {
        //TODO: invest
    }
}


