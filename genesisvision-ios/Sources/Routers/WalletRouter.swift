//
//  WalletRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletRouteType {
    case withdraw
}

class WalletRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletRouteType) {
        switch routeType {
        case .withdraw:
            withdraw()
        }
    }
    
    // MARK: - Private methods
    private func withdraw() {
        //TODO: withdraw
    }
}
