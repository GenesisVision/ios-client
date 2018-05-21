//
//  ForgotPasswordRouter.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ForgotPasswordRouteType {
    case forgotPasswordInfo
}

class ForgotPasswordRouter: Router {
    // MARK: - Public methods
    func show(routeType: ForgotPasswordRouteType) {
        switch routeType {
        case .forgotPasswordInfo:
            showForgotPasswordInfo()
        }
    }
    
    // MARK: - Private methods
    private func showForgotPasswordInfo() {
        guard let viewController = InfoViewController.storyboardInstance(name: .auth) else { return }
        let router = Router(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = ForgotPasswordInfoViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
