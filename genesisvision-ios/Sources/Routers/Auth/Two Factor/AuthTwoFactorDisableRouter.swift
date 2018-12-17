//
//  AuthTwoFactorDisableRouter.swift
//  genesisvision-ios
//
//  Created by George on 01/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum AuthTwoFactorDisableRouteType {
    case successDisable
}

class AuthTwoFactorDisableRouter: TabmanRouter {
    
    // MARK: - Public methods
    func show(routeType: AuthTwoFactorDisableRouteType) {
        switch routeType {
        case .successDisable:
            showSuccessDisableVC()
        }
    }
    
    // MARK: - Private methods
    // MARK: - Private methods
    private func getSuccessDisableVC() -> InfoViewController? {
        guard let viewController = InfoViewController.storyboardInstance(.auth) else { return nil }
        viewController.viewModel = AuthTwoFactorSuccessDisableViewModel(withRouter: self)
        
        return viewController
    }
    
    private func showSuccessDisableVC() {
        guard let viewController = getSuccessDisableVC() else { return }
        present(viewController: viewController)
    }
}


