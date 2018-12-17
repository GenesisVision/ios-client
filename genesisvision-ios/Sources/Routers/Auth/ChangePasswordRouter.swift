//
//  ChangePasswordRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ChangePasswordRouteType {
    case changePasswordInfo
}

class ChangePasswordRouter: Router {
    // MARK: - Public methods
    func show(routeType: ChangePasswordRouteType) {
        switch routeType {
        case .changePasswordInfo:
            showChangePasswordInfo()
        }
    }
    
    // MARK: - Private methods
    private func showChangePasswordInfo() {
        guard let viewController = InfoViewController.storyboardInstance(.auth) else { return }
        let router = Router(parentRouter: self)
        viewController.viewModel = AuthChangePasswordInfoViewModel(withRouter: router)
        present(viewController: viewController)
    }
}

