//
//  ProgramInvestRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramInvestRouteType {
    case confirm
}

class ProgramInvestRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramInvestRouteType) {
        switch routeType {
        case .confirm:
            confirm()
        }
    }
    
    // MARK: - Private methods
    private func confirm() {
        //TODO: confirm screen
    }
}
