//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDetailRouteType {
    case invest, withdraw, history
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest:
            invest()
        case .withdraw:
            invest()
        case .history:
            invest()
        }
    }
    
    // MARK: - Private methods
    private func invest() {
        //TODO: invest
    }
    
    private func withdraw() {
        //TODO: withdraw
    }
    
    private func history() {
        //TODO: history
    }
}

