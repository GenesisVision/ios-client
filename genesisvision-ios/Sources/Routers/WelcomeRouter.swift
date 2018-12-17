//
//  WelcomeRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WelcomeRouteType {
    case startAsAuthorized, startAsUnauthorized
}

class WelcomeRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WelcomeRouteType) {
        switch routeType {
        case .startAsAuthorized:
            startAsAuthorized()
        case .startAsUnauthorized:
            startAsUnauthorized()
        }
    }
}
