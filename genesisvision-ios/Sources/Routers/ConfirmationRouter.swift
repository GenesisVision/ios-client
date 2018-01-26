//
//  ConfirmationRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ConfirmationRouteType {
    case popToTraderList
}

class ConfirmationRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ConfirmationRouteType) {
        switch routeType {
        case .popToTraderList:
            popToTraderList()
        }
    }
    
    // MARK: - Private methods
    private func popToTraderList() {
        popToRootViewController()
    }
}
