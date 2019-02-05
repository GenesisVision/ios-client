//
//  AuthTwoFactorTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 31/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum AuthTwoFactorTabmanRouteType {
    case successEnable([String])
}

class AuthTwoFactorTabmanRouter: TabmanRouter {
    
    // MARK: - Public methods
    func show(routeType: AuthTwoFactorTabmanRouteType) {
        switch routeType {
        case .successEnable(let recoveryCodes):
            showSuccessEnableVC(recoveryCodes)
        }
    }
    
    func getCreateVC(with tabmanViewModel: AuthTwoFactorTabmanViewModel) -> AuthTwoFactorCreateViewController? {
        guard let viewController = AuthTwoFactorCreateViewController.storyboardInstance(.auth) else { return  nil }
        viewController.viewModel = AuthTwoFactorCreateViewModel(withRouter: self, tabmanViewModel: tabmanViewModel)
        
        return viewController
    }
    
    func getTutorialVC(with tabmanViewModel: AuthTwoFactorTabmanViewModel) -> AuthTwoFactorTutorialViewController? {
        guard let viewController = AuthTwoFactorTutorialViewController.storyboardInstance(.auth) else { return  nil }
        viewController.viewModel = AuthTwoFactorTutorialViewModel(withRouter: self, tabmanViewModel: tabmanViewModel)
        
        return viewController
    }
    
    func getConfirmationVC(with tabmanViewModel: AuthTwoFactorTabmanViewModel) -> AuthTwoFactorConfirmationViewController? {
        guard let viewController = AuthTwoFactorConfirmationViewController.storyboardInstance(.auth) else { return  nil }
        viewController.viewModel = AuthTwoFactorEnableConfirmationViewModel(withRouter: self, tabmanViewModel: tabmanViewModel)
        
        return viewController
    }
    
    // MARK: - Private methods
    private func getSuccessEnableVC(with recoveryCodes: [String]) -> InfoViewController? {
        guard let viewController = InfoViewController.storyboardInstance(.auth) else { return nil }
        viewController.viewModel = AuthTwoFactorSuccessEnableViewModel(withRouter: self, recoveryCodes: recoveryCodes)
        
        return viewController
    }
    
    private func showSuccessEnableVC(_ recoveryCodes: [String]) {
        guard let viewController = getSuccessEnableVC(with: recoveryCodes) else { return }
        present(viewController: viewController)
    }
}
