//
//  AuthTwoFactorSuccessDisableViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorSuccessDisableViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = String.Info.TwoFactor.twoFactorDisableSuccess
    var recoveryCodes = [String]()
    
    var iconImage: UIImage = #imageLiteral(resourceName: "email-confirmed-icon")
    var backgroundColor: UIColor = UIColor.InfoView.bg
    var textColor: UIColor = UIColor.InfoView.text
    var tintColor: UIColor = UIColor.InfoView.tint
    var textFont: UIFont = UIFont.getFont(.regular, size: 24)
    
    var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    func goBack() {
        router.closeVC()
        router.goToBack(animated: false)
    }
}

