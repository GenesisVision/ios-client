//
//  SignInRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum SignInRouteType {
    case startAsAuthorized, signUp, forgotPassword, twoFactorSignIn(email: String, password: String)
}

class SignInRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: SignInRouteType) {
        switch routeType {
        case .startAsAuthorized:
            startAsAuthorized()
        case .signUp:
            signUpAction()
        case .forgotPassword:
            forgotPasswordAction()
        case .twoFactorSignIn(let email, let password):
            twoFactorSignInAction(email: email, password: password)
        }
    }
    
    // MARK: - Private methods
    // MARK: - Navigation
    private func signUpAction() {
        guard let viewController = SignUpViewController.storyboardInstance(.auth) else { return }
        let router = SignUpRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthSignUpViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func forgotPasswordAction() {
        guard let viewController = ForgotPasswordViewController.storyboardInstance(.auth) else { return }
        let router = ForgotPasswordRouter(parentRouter: self, navigationController: navigationController) 
        viewController.viewModel = AuthForgetPasswordViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func twoFactorSignInAction(email: String, password: String) {
        guard let viewController = AuthTwoFactorSignInViewController.storyboardInstance(.auth) else { return }
        let router = AuthTwoFactorSignInRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthTwoFactorSignInViewModel(withRouter: router, email: email, password: password)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
