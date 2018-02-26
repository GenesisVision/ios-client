//
//  ProgramWithdrawRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIViewController

enum ProgramWithdrawRouteType {
    case withdrawRequested
}

class ProgramWithdrawRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramWithdrawRouteType) {
        switch routeType {
        case .withdrawRequested:
            withdrawRequested()
        }
    }
    
    // MARK: - Private methods
    private func withdrawRequested() {
        //TODO: withdrawRequested
    }
}
