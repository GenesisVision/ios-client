//
//  ProgramWithdrawSuccessViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class ProgramWithdrawSuccessViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = String.Info.withdrawRequestSuccess
    var iconImage: UIImage = #imageLiteral(resourceName: "email-confirmed-icon")
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
        router.goToSecond()
    }
}
