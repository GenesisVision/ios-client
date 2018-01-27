//
//  SignUpRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum SignUpRouteType {
    case confirmation
}

class SignUpRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: SignUpRouteType) {
        switch routeType {
        case .confirmation:
            confirmationAction()
        }
    }
    
    // MARK: - Private methods
    private func confirmationAction() {
        guard let viewController = ConfirmationViewController.storyboardInstance(name: .auth) else { return }
        let router = ConfirmationRouter(parentRouter: self, navigationController: navigationController)
        childRouters.append(router)
        viewController.viewModel = ConfirmationViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
