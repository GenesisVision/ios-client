//
//  WalletWithdrawRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum WalletWithdrawRouteType {
    case withdraw, readQRCode
}

class WalletWithdrawRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletWithdrawRouteType) {
        switch routeType {
        case .withdraw:
            withdraw()
        case .readQRCode:
            readQRCode()
        }
    }
    
    // MARK: - Private methods
    private func withdraw() {
        //Withdraw
    }
    
    private func readQRCode() {
        //read QR code
        //return address string
    }
}
