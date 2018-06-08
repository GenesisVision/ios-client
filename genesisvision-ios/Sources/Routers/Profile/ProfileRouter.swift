//
//  ProfileRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProfileRouteType {
    case signOut, forceSignOut, changePassword, enableTwoFactor(Bool)
}

class ProfileRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProfileRouteType) {
        switch routeType {
        case .signOut:
            signOut()
        case .forceSignOut:
            forceSignOut()
        case .changePassword:
            changePassword()
        case .enableTwoFactor(let value):
            enableTwoFactor(value)
        }
    }
    
    // MARK: - Private methods
    private func signOut() {
        startAsUnauthorized()
    }
    
    private func forceSignOut() {
        startAsForceSignOut()
    }
    
    private func changePassword() {
        guard let viewController = ChangePasswordViewController.storyboardInstance(name: .auth) else { return }
        let router = ChangePasswordRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthChangePasswordViewModel(withRouter: router)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func enableTwoFactor(_ value: Bool) {
        guard let viewController = value ? getTwoFactorEnableViewController() : getTwoFactorDisableViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
