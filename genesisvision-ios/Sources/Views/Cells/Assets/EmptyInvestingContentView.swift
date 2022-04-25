//
//  EmptyInvestingContentView.swift
//  genesisvision-ios
//
//  Created by Gregory on 19.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class EmptyInvestingContentView : UIStackView {
    @IBOutlet weak var disclaimerLabel: SubtitleLabel!
    @IBOutlet weak var findButtonLabel: UIButton!
    var type: AssetType?
    @IBAction func findButtonAction(_ sender: UIButton) {
        let userInfo = ["type" : type]
        NotificationCenter.default.post(name: .findAsset, object: nil, userInfo: userInfo)
    }
}

extension EmptyInvestingContentView: ContentViewProtocol {
    func configure(type: AssetType) {
        self.type = type
        switch type {
        case .program:
            disclaimerLabel.text = Constants.CoinAssetsConstants.emptyInvestmentDisclaimer + Constants.CoinAssetsConstants.program
            let buttonTitle = Constants.CoinAssetsConstants.find + " " + Constants.CoinAssetsConstants.program
            findButtonLabel.setTitle(buttonTitle, for: .normal)
        case .fund:
            disclaimerLabel.text = Constants.CoinAssetsConstants.emptyInvestmentDisclaimer + Constants.CoinAssetsConstants.fund
            let buttonTitle = Constants.CoinAssetsConstants.find + " " + Constants.CoinAssetsConstants.fund
            findButtonLabel.setTitle(buttonTitle, for: .normal)
        case .coinAsset:
            disclaimerLabel.text = Constants.CoinAssetsConstants.emptyInvestmentDisclaimer + Constants.CoinAssetsConstants.asset
            let buttonTitle = Constants.CoinAssetsConstants.find + " " + Constants.CoinAssetsConstants.asset
            findButtonLabel.setTitle(buttonTitle, for: .normal)
        default:
            break
        }
    }
}
