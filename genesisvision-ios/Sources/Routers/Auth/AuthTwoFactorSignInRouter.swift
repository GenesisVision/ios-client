//
//  AuthTwoFactorSignInRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum AuthTwoFactorSignInRouteType {
    case startAsAuthorized
    case threeFactorSignIn(email: String, password: String)
}

class AuthTwoFactorSignInRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: AuthTwoFactorSignInRouteType) {
        switch routeType {
        case .startAsAuthorized:
            startAsAuthorized()
        case .threeFactorSignIn(let email, let password):
            showThreeFactorSignIn(email: email, password: password)
        }
    }
    
    func showThreeFactorSignIn(email: String, password: String) {
        guard let viewController = AuthThreeFactorSignInViewController.storyboardInstance(.auth) else { return }
        viewController.viewModel = AuthThreeFactorSignInViewModel(withRouter: self, email: email, password: password)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

