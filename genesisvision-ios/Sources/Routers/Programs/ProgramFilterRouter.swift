//
//  ProgramFilterRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramFilterRouteType {
    case reset
}

class ProgramFilterRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProgramFilterRouteType) {
        switch routeType {
        case .reset:
            reset()
        }
    }
    
    // MARK: - Private methods
    private func reset() {
        //TODO: reset
    }
}


