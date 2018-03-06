//
//  WalletFilterRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletFilterRouteType {
    case reset
}

class WalletFilterRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletFilterRouteType) {
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



