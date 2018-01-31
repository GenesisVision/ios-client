//
//  FilterRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum FilterRouteType {
    case reset
}

class FilterRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: FilterRouteType) {
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


