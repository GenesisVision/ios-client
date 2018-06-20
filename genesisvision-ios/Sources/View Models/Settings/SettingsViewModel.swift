
//
//  SettingsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 13/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class SettingsViewModel {
    enum SettingsRowType: String, EnumCollection {
        case profile = "Profile"
        
        case changePassword = "Change Password"
        case passcode = "Passcode"
        case biometricID = "Touch ID"
        case twoFactor = "Two Factor"
        
        case sendFeedback = "Send Feedback"
        
        case signOut = "Log Out"
        
        case none
    }
    
    
    enum SettingsSectionType: String {
        case profile
        case security
        case feedback
        case signOut
    }
    
    // MARK: - Variables
    var title: String = "Settings"
    
    var enablePasscode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.UserDefaults.passcodeEnable)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.passcodeEnable)
            
            if !newValue {
                enableBiometricID = newValue
            }
        }
    }
    
    var enableBiometricID: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.UserDefaults.biometricEnable)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.biometricEnable)
        }
    }
    
    var enableTwoFactor: Bool = false
    
    private var router: SettingsRouter!
    
    public private(set) var twoFactorModel: TwoFactorStatus? {
        didSet {
            if let twoFactorEnabled = twoFactorModel?.twoFactorEnabled {
                enableTwoFactor = twoFactorEnabled
            }
        }
    }
    private var profileModel: ProfileFullViewModel?
    
    var sections: [SettingsSectionType] = [.profile, .security, .feedback, .signOut]
    var rows: [SettingsSectionType : [SettingsRowType]] = [.profile : [.profile],
                                                           .security : [.changePassword, .passcode, .biometricID, .twoFactor],
                                                           .feedback : [.sendFeedback],
                                                           .signOut : [.signOut]]
    
    var fullName: String? {
        let firstName = self.profileModel?.firstName ?? ""
        let lastName = self.profileModel?.lastName ?? ""
        let name = (firstName + " " + lastName).trimmingCharacters(in: .whitespaces)
        
        return name.isEmpty ? nil : name
    }
    
    var avatarURL: URL? {
        guard let avatar = profileModel?.avatar,
            let avatarURL = getFileURL(fileName: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    var email: String {
        guard let email = profileModel?.email else { return "" }
        
        return email
    }
    
    // MARK: - Init
    init(withRouter router: SettingsRouter) {
        self.router = router
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
    }
    
    // MARK: - Public methods
    func fetchProfile(completion: @escaping CompletionBlock) {
        AuthManager.getProfile(completion: { [weak self] (viewModel) in
            if let profileModel = viewModel {
                self?.profileModel = profileModel
                completion(.success)
            }
            
            completion(.failure(errorType: .apiError(message: nil)))
            }, completionError: completion)
    }
    
    func fetchTwoFactorStatus(completion: @escaping CompletionBlock) {
        AuthManager.getTwoFactorStatus(completion: { [weak self] (viewModel) in
            if let twoFactorModel = viewModel {
                self?.twoFactorModel = twoFactorModel
                completion(.success)
            }
            
            completion(.failure(errorType: .apiError(message: nil)))
            }, completionError: completion)
    }
    
    func rowType(at indexPath: IndexPath) -> SettingsRowType? {
        let sectionType = sections[indexPath.section]
        
        guard let rows = rows[sectionType] else { return nil }
        
        return rows[indexPath.row]
    }
    
    // MARK: - Navigation
    func showProfile() {
        guard let profileModel = profileModel else { return }
        router.show(routeType: .showProfile(profileModel))
    }
    
    func changePassword() {
        router.show(routeType: .changePassword)
    }
    
    func enablePasscode(_ value: Bool) {
        router.show(routeType: .enablePasscode(value))
        enablePasscode = value
    }
    
    func enableBiometricID(_ value: Bool) {
        enableBiometricID = value
    }
    
    func enableTwoFactor(_ value: Bool) {
        router.show(routeType: .enableTwoFactor(value))
    }
    
    func sendFeedback() {
        router.show(routeType: .feedback)
    }
    
    func showTerms() {
        router.show(routeType: .terms)
    }
    
    func showPrivacy() {
        router.show(routeType: .privacy)
    }
    
    func signOut() {
        clearData()
        router.show(routeType: .signOut)
    }
    
    // MARK: -  Private methods
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotification(notification:)), name: .signOut, object: nil)
        
        fetchProfile { (result) in }
    }
    
    private func clearData() {
        AuthManager.signOut()
        profileModel = nil
    }
    
    private func forceSignOut() {
        clearData()
        router.show(routeType: .forceSignOut)
    }
    
    @objc private func signOutNotification(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
        forceSignOut()
    }
}

