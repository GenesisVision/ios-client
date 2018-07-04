//
//  PasscodeViewModel.swift
//  genesisvision-ios
//
//  Created by George on 19/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum PasscodeState {
    case enable, disable, lock, openApp
}

final class PasscodeViewModel {
    // MARK: - Variables
    var title: String = "Passcode"
    var passwordDigit: Int = 4
    var deleteButtonTitle: String = "Delete"
    var isVibrancyEffect: Bool = true
    var labelFont: UIFont = UIFont.getFont(.regular, size: 29)
    
    var titleLabelText = "Enter Passcode"
    var againTitleLabelText = "Enter Passcode Again"
    
    var changedMessageEnable: Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.biometricEnable)
        && domainStateChanged
    }
    
    var changedAlertTexts: (String, String) {
        return (String.Alerts.BiometricIDChanged.alertTitle.replacingOccurrences(of: "BiometricID", with: BiometricIDAuthManager.shared.biometricTitleText), String.Alerts.BiometricIDChanged.alertMessage.replacingOccurrences(of: "BiometricID", with: BiometricIDAuthManager.shared.biometricTitleText))
    }
    
    private var domainStateChanged: Bool {
        return BiometricIDAuthManager.shared.domainStateChanged()
    }
    
    var touchAuthenticationEnabled: Bool {
        guard !domainStateChanged else {
            return false
        }
        
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.biometricEnable) && BiometricIDAuthManager.shared.isTouchAuthenticationAvailable
    }
    
    public private(set) var passcode: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaults.passcode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.passcode)
        }
    }
    
    private var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    // MARK: - Public methods
    func updatePasscode(_ value: String?) {
        passcode = value
    }
    
    // MARK: - Navigation
    func closeVC() {
        router.dismiss(animated: true)
    }
}


