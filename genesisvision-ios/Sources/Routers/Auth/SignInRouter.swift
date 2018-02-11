//
//  SignInRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum SignInRouteType {
    case startAsAuthorized, signUp
}

class SignInRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: SignInRouteType) {
        switch routeType {
        case .startAsAuthorized:
            startAsAuthorized()
        case .signUp:
            signUpAction()
        }
    }
    
    // MARK: - Private methods
    // MARK: - Navigation
    private func signUpAction() {
        guard let viewController = SignUpViewController.storyboardInstance(name: .auth) else { return }
        let router = SignUpRouter(parentRouter: self)
        router.navigationController = navigationController
        childRouters.append(router)
        viewController.viewModel = SignUpViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
