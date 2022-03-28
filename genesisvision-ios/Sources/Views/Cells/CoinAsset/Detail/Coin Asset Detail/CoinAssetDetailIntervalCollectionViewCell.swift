//
//  CoinAssetDetailIntervalCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by Gregory on 23.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetDetailIntervalCollectionViewCell : UICollectionViewCell {
    
    let intervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configure(button : KlineIntervalButton) {
        intervalLabel.text = button.title.rawValue
        addSubview(intervalLabel)
        intervalLabel.fillSuperview()
        if button.isCurrent {
            intervalLabel.font = UIFont.getFont(.semibold, size: 16)
            intervalLabel.textColor = UIColor.Font.primary
        } else {
            intervalLabel.font = UIFont.getFont(.semibold, size: 16)
            intervalLabel.textColor = UIColor.Font.medium
        }
    }
}
