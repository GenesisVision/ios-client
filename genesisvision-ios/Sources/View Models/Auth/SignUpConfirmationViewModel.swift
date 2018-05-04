//
//  ConfirmationViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class SignUpConfirmationViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = String.Info.signUpConfirmationSuccess
    var iconImage: UIImage = #imageLiteral(resourceName: "confirm-email-icon")
    var backgroundColor: UIColor = UIColor.InfoView.bg
    var textColor: UIColor = UIColor.InfoView.text
    var tintColor: UIColor = UIColor.InfoView.tint
    var textFont: UIFont = UIFont.getFont(.regular, size: 36)
    
    var router: Router!

    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    func goBack() {
        router.goToRoot()
    }
}
