//
//  AuthTwoFactorSignInRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum AuthTwoFactorSignInRouteType {
    case startAsAuthorized
}

class AuthTwoFactorSignInRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: AuthTwoFactorSignInRouteType) {
        switch routeType {
        case .startAsAuthorized:
            startAsAuthorized()
        }
    }
}

