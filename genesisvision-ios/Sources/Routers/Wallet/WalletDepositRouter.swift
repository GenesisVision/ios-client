//
//  WalletDepositRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletDepositRouteType {
    case copy
}

class WalletDepositRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletDepositRouteType) {
        switch routeType {
        case .copy:
            copy()
        }
    }
    
    // MARK: - Private methods
    private func copy() {
        //Copy Address
    }
}

