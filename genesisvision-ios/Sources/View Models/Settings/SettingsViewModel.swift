
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
        
        case changePassword = "Change password"
        case passcode = "Passcode"
        case biometricID = "Touch ID"
        case twoFactor = "Two-factor authentication"
        
        case darkTheme = "Dark theme"
        
        case termsAndConditions = "Terms and conditions"
        case privacyPolicy = "Privacy policy"
        case contactUs = "Contact us"
        
        case none
    }
    
    enum SettingsSectionType: String {
        case profile
        case security
        case darkTheme
        case feedback
    }
    
    // MARK: - Variables
    var title: String = "Settings"
    
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    
    let biometricIDAuthManager = BiometricIDAuthManager.shared
    
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
            guard !biometricIDAuthManager.domainStateChanged() else {
                UserDefaults.standard.set(false, forKey: Constants.UserDefaults.biometricEnable)
                return false
            }
            
            return UserDefaults.standard.bool(forKey: Constants.UserDefaults.biometricEnable)
        }
        set {
            if newValue {
                biometricIDAuthManager.updateLastDomainState()
            }
            
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.biometricEnable)
        }
    }
    
    var enableTwoFactor: Bool = false
    var enableBiometricCell: Bool {
        return biometricIDAuthManager.isTouchAuthenticationAvailable && enablePasscode
    }
    
    var enableDarkTheme: Bool {
        get {
            return AppearanceController.theme == .darkTheme
        }
        set {
            AppearanceController.theme = newValue ? .darkTheme : .lightTheme
        }
    }
    
    var biometricTitleText: String {
        return biometricIDAuthManager.biometricTitleText
    }
    
    private var router: SettingsRouter!
    
    public private(set) var twoFactorModel: TwoFactorStatus? {
        didSet {
            if let twoFactorEnabled = twoFactorModel?.twoFactorEnabled {
                enableTwoFactor = twoFactorEnabled
            }
        }
    }
    private var profileModel: ProfileFullViewModel?
    
    var sections: [SettingsSectionType] = [.profile, .security, .feedback]
    var rows: [SettingsSectionType : [SettingsRowType]] = [.profile : [.profile],
                                                           .security : [.changePassword, .passcode, .biometricID, .twoFactor],
                                                           .feedback : [.termsAndConditions, .privacyPolicy, .contactUs]]
    
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
    
    var verificationStatus: ProfileFullViewModel.VerificationStatus? {
        guard let verificationStatus = profileModel?.verificationStatus else { return nil }
        
        return verificationStatus
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
            self?.twoFactorModel = viewModel
            completion(.success)
            }, completionError: completion)
    }
    
    func rowType(at indexPath: IndexPath) -> SettingsRowType? {
        let sectionType = sections[indexPath.section]
        
        guard let rows = rows[sectionType] else { return nil }
        
        return rows[indexPath.row]
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 0.0
        default:
            return 20.0
        }
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
    }
    
    func enableBiometricID(_ value: Bool) {
        enableBiometricID = value
    }
    
    func enableTwoFactor(_ value: Bool) {
        router.show(routeType: .enableTwoFactor(value))
    }
    
    func enableDarkTheme(_ value: Bool) {
        AppearanceController.theme = value ? .darkTheme : .lightTheme
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
    
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImageURL = pickedImageURL else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult.id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            ProfileDataProvider.updateProfileAvatar(fileId: uuidString, completion: { [weak self] (result) in
                switch result {
                case .success:
                    self?.profileModel?.avatar = uuidString
                    completion(.success)
                case .failure(let errorType):
                    print(errorType)
                    break
                }
            })
        }, errorCompletion: completion)
    }
    
    @objc private func signOutNotification(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
        forceSignOut()
    }
}

