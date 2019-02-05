//
//  AuthTwoFactorSuccessEnableViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorSuccessEnableViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = String.Info.TwoFactor.twoFactorEnableSuccess
    var recoveryCodes = [String]()
    
    var iconImage: UIImage? = nil
    var backgroundColor: UIColor = UIColor.BaseView.bg
    var textColor: UIColor = UIColor.Cell.subtitle
    var tintColor: UIColor = UIColor.InfoView.tint
    var textFont: UIFont = UIFont.getFont(.regular, size: 14.0)
    
    var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router, recoveryCodes: [String]) {
        self.router = router
        self.recoveryCodes = recoveryCodes
        text.append("\n\n")
        text.append(String.Info.TwoFactor.twoFactorEnableRecoveryCodes + "\n")
        text.append("\n")
        
        var codes: String = ""
        
        for (idx, item) in recoveryCodes.enumerated() {
            codes.append(item)
            codes.append((idx + 1) % 3 == 0 ? "\n" : "\t\t")
        }
        
        text.append(codes)
    }
    
    func goBack() {
        router.closeVC()
        router.goToBack(animated: false)
    }
}
