//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DashboardRouteType {
    case invest
}

class DashboardRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
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
