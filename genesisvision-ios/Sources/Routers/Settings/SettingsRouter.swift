//
//  SettingsRouter.swift
//  genesisvision-ios
//
//  Created by George on 13/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

enum SettingsRouteType {
    case signOut, forceSignOut, changePassword, enableTwoFactor(Bool), enablePasscode(Bool), showProfile(ProfileFullViewModel), feedback, terms, privacy, referral, kyc(ExternalKycAccessToken), showProfilePrivacy(ProfileFullViewModel), showSocialProfile(String)
}

class SettingsRouter: Router {
    
    var settingsViewController: SettingsViewController?
    
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
        case .showProfile(let profileModel):
            showProfile(profileModel)
        case .feedback:
            showFeedback()
        case .terms:
            showTerms()
        case .privacy:
            showPrivacy()
        case .referral:
            showReferral()
        case .kyc(let kycTokens):
            showKYC(verificationTokens: kycTokens)
        case .showProfilePrivacy(let profileModel):
            showProfilePrivacy(profileModel)
        case .showSocialProfile(let id):
            showUserDetails(with: id)
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
        guard let viewController = ChangePasswordViewController.storyboardInstance(.auth) else { return }
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
        let window = UIApplication.shared.windows[0]
        guard let viewController = PasscodeViewController.storyboardInstance(.settings), let rootViewController = window.rootViewController, let settingsViewController = settingsViewController else { return }
        
        let router = Router(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = PasscodeViewModel(withRouter: router)
        
        viewController.delegate = settingsViewController
        
        viewController.passcodeState = value ? .enable : .disable
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        
        rootViewController.present(viewController: viewController)
    }
    
    private func showFeedback() {
        navigationController?.openSafariVC(with: Urls.feedbackWebAddress)
    }
    
    private func showProfile(_ profileModel: ProfileFullViewModel) {
        guard let viewController = ProfileViewController.storyboardInstance(.profile) else { return }
        let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = ProfileViewModel(withRouter: router, profileModel: profileModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showReferral() {
        let viewController = ReferralProgramViewController()
        let viewModel = ReferralProgramViewModel(with: self)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showKYC(verificationTokens: ExternalKycAccessToken) {
        let viewController = KYCInfoViewController()
        let viewModel = KYCInfoViewControllerViewModel(verificationTokens: verificationTokens)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showProfilePrivacy(_ profileModel: ProfileFullViewModel) {
        let viewController = ProfilePrivacyViewController()
        let viewModel = ProfilePrivacyViewModel(profile: profileModel)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

