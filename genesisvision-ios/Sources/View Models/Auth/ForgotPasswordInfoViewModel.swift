//
//  ForgotPasswordInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class ForgotPasswordInfoViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = "we sent a password reset link to the email you specified.\n\nplease follow this link to reset your password."
    var iconImage: UIImage = #imageLiteral(resourceName: "confirm-email-icon")
    var backgroundColor: UIColor = UIColor.Background.primary
    var textColor: UIColor = UIColor.Font.white
    var tintColor: UIColor = UIColor.Font.white
    var textFont: UIFont = UIFont.getFont(.regular, size: 24)
    
    var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    func goBack() {
        router.goToRoot()
    }
}

