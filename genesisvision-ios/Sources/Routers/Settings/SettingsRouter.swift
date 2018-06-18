//
//  SettingsRouter.swift
//  genesisvision-ios
//
//  Created by George on 13/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum SettingsRouteType {
    case signOut, forceSignOut, changePassword, enableTwoFactor(Bool), enablePasscode(Bool), enableBiometricID(Bool), showProfile(ProfileFullViewModel), feedback, terms, privacy
}

class SettingsRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: SettingsRouteType) {
        switch routeType {
        case .signOut:
            signOut()
        case .forceSignOut:
            forceSignOut()
        case .changePassword:
            changePassword()
        case .enableTwoFactor(let value):
            enableTwoFactor(value)
        case .enablePasscode(let value):
            enablePasscode(value)
        case .enableBiometricID(let value):
            enableBiometricID(value)
        case .showProfile(let profileModel):
            showProfile(profileModel)
        case .feedback:
            showFeedback()
        case .terms:
            showTerms()
        case .privacy:
            showPrivacy()
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
    
    private func enablePasscode(_ value: Bool) {
        
    }
    
    private func enableBiometricID(_ value: Bool) {
        
    }
    
    private func showFeedback() {
        navigationController?.openSafariVC(with: Constants.Urls.feedbackWebAddress)
    }
    
    private func showTerms() {
        navigationController?.openSafariVC(with: Constants.Urls.termsWebAddress)
    }
    
    private func showPrivacy() {
        navigationController?.openSafariVC(with: Constants.Urls.privacyWebAddress)
    }
    
    private func showProfile(_ profileModel: ProfileFullViewModel) {
        guard let viewController = ProfileViewController.storyboardInstance(name: .profile) else { return }
        let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = ProfileViewModel(withRouter: router, profileModel: profileModel, textFieldDelegate: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

