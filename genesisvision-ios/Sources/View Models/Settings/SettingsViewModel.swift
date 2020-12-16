
//
//  SettingsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 13/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class SettingsViewModel {
    enum RowType: String, EnumCollection {
        case profile = "Profile"
        case kycStatus = "KYC Status"
        case publicProfile = "Public investor's profile"
        
        case currency = "Platform currency"
        case referralProgram = "Referral program"
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
    
    enum SectionType: String {
        case profile
        case currency
        case security
        case darkTheme
        case feedback
    }
    
    // MARK: - Variables
    var title: String = "Settings"
    
    var pickedImage: UIImage?
    
    let biometricIDAuthManager = BiometricIDAuthManager.shared
    
    var currencyListViewModel: PlatformCurrencyListViewModel! {
        didSet {
            delegate?.didReload(IndexPath(row: 0, section: 1))
        }
    }
    var currencyListDataSource: TableViewDataSource!
    var platformCurrencies: [PlatformCurrencyInfo]?
    
    var enablePasscode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.passcodeEnable)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.passcodeEnable)
            
            if !newValue {
                enableBiometricID = newValue
            }
        }
    }
    
    var enableBiometricID: Bool {
        get {
            guard !biometricIDAuthManager.domainStateChanged() else {
                UserDefaults.standard.set(false, forKey: UserDefaultKeys.biometricEnable)
                return false
            }
            
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.biometricEnable)
        }
        set {
            if newValue {
                biometricIDAuthManager.updateLastDomainState()
            }
            
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.biometricEnable)
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
    
    var kycVerificationTokens: ExternalKycAccessToken?
    
    var sections: [SectionType] = [.profile, .currency, .security, .feedback]
    var rows: [SectionType : [RowType]] = [.profile : [.profile, .kycStatus, .publicProfile],
                                           .currency : [.currency, .referralProgram],
                                           .security : [.changePassword, .passcode, .biometricID, .twoFactor],
                                           .feedback : [.termsAndConditions, .privacyPolicy, .contactUs]]
    
    var fullName: String? {
        let firstName = self.profileModel?.firstName ?? ""
        let lastName = self.profileModel?.lastName ?? ""
        let name = (firstName + " " + lastName).trimmingCharacters(in: .whitespaces)
        
        return name.isEmpty ? nil : name
    }
    
    var username: String? {
        return self.profileModel?.userName
    }
    
    var avatarURL: URL? {
        guard let avatar = profileModel?.logoUrl,
            let avatarURL = URL(string: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    var isPublic: Bool {
        guard let isPublicInvestor = profileModel?.isPublicInvestor else { return false }
        return isPublicInvestor
    }
    
    var email: String {
        guard let email = profileModel?.email else { return "" }
        
        return email
    }
    
    var verificationStatus: UserVerificationStatus? {
        guard let verificationStatus = profileModel?.verificationStatus else { return nil }
        
        return verificationStatus
    }
    
    weak var delegate: BaseTableViewProtocol?
    
    // MARK: - Init
    init(withRouter router: SettingsRouter, delegate: BaseTableViewProtocol?) {
        self.router = router
        self.delegate = delegate
        
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
    
    func rowType(at indexPath: IndexPath) -> RowType? {
        let sectionType = sections[indexPath.section]
        
        guard let rows = rows[sectionType] else { return nil }
        
        return rows[indexPath.row]
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return Constants.headerHeight
        }
    }
    
    // MARK: - Navigation
    func showProfile() {
        guard let profileModel = profileModel else { return }
        router.show(routeType: .showProfile(profileModel))
    }
    func publicChange(_ value: Bool, completion: @escaping CompletionBlock) {
        ProfileDataProvider.publicChange(value, completion: completion)
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
    
    func showReferral() {
        router.show(routeType: .referral)
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
    
    func showKYC() {
        guard let kycVerificationTokens = kycVerificationTokens else { return }
        router.show(routeType: .kyc(kycVerificationTokens))
    }
    
    // MARK: -  Private methods
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotification(notification:)), name: .signOut, object: nil)
        
        fetchProfile { (result) in }
        
        PlatformManager.shared.getPlatformInfo { [weak self] (info) in
            if let platformCurrencies = info?.commonInfo?.platformCurrencies {
                self?.currencyListViewModel = PlatformCurrencyListViewModel(self?.delegate, items: platformCurrencies, selectedIndex: platformCurrencies.firstIndex(where:  { $0.name == selectedPlatformCurrency }) ?? 0)
                if let currencyListViewModel = self?.currencyListViewModel {
                    self?.currencyListDataSource = TableViewDataSource(currencyListViewModel)
                }
            }
        }
        
        ProfileDataProvider.getMobileVErificationTokens { [weak self] (viewModel) in
            if let viewModel = viewModel {
                self?.kycVerificationTokens = viewModel
            }
        } errorCompletion: { (_) in }
    }
    
    private func clearData() {
        if let fcmToken = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken) {
            ProfileDataProvider.removeFCMToken(token: fcmToken) { (result) in }
        }
        AuthManager.signOut()
        profileModel = nil
        
    }
    
    private func forceSignOut() {
        clearData()
        router.show(routeType: .forceSignOut)
    }
    
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImage = pickedImage?.pngData() else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        
        BaseDataProvider.uploadImage(imageData: pickedImage, imageLocation: .user, completion: { (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            ProfileDataProvider.updateProfileAvatar(fileId: uuidString, completion: { [weak self] (result) in
                switch result {
                case .success:
                    self?.profileModel?.logoUrl = uuidString
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
