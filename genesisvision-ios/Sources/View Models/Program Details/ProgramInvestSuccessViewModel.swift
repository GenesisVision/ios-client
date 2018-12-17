//
//  ProgramInvestSuccessViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class ProgramInvestSuccessViewModel: InfoViewModel {
    // MARK: - Variables
    var text: String = String.Info.investmentRequestSuccess
    var investedAmount: Double = 0.0
    
    var iconImage: UIImage? = #imageLiteral(resourceName: "email-confirmed-icon")
    var backgroundColor: UIColor = UIColor.InfoView.bg
    var textColor: UIColor = UIColor.InfoView.text
    var tintColor: UIColor = UIColor.InfoView.tint
    var textFont: UIFont = UIFont.getFont(.regular, size: 24)
    
    var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router, investedAmount: Double) {
        self.router = router
        self.investedAmount = investedAmount
        text = String.Info.investmentRequestSuccess.replacingOccurrences(of: "<N>", with: investedAmount.rounded(withType: .gvt).toString())
    }
    
    func goBack() {
        router.closeVC()
        router.goToBack(animated: false)
    }
}
