//
//  ProgramDescriptionRouter.swift
//  genesisvision-ios
//
//  Created by George on 23/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDescriptionRouteType {
    case dismiss
}

class ProgramDescriptionRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDescriptionRouteType) {
        switch routeType {
        case .dismiss:
            dismiss()
        }
    }
    
    // MARK: - Private methods
    private func dismiss() {
        //TODO:
    }
}

