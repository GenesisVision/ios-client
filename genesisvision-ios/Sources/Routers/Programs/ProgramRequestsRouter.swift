//
//  ProgramRequestsRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum ProgramRequestsRouteType {
    case cancel(requestId: String), goBack
}

class ProgramRequestsRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProgramRequestsRouteType) {
        switch routeType {
        case .cancel(let requestId):
            cancel(with: requestId)
        case .goBack:
            popViewController(animated: true)
        }
    }
    
    // MARK: - Private methods
    private func cancel(with requestId: String) {
    }
}

