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
    var text: String = "please confirm \nyour email."
    var iconImage: UIImage = #imageLiteral(resourceName: "confirm-email-icon")
    var backgroundColor: UIColor = UIColor.Background.primary
    var textColor: UIColor = UIColor.Font.white
    var tintColor: UIColor = UIColor.Font.white
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
