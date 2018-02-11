//
//  ProfileRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProfileRouteType {
    case signOut
}

class ProfileRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProfileRouteType) {
        switch routeType {
        case .signOut:
            signOut()
        }
    }
    
    // MARK: - Private methods
    private func signOut() {
        startAsUnauthorized()
    }
}
