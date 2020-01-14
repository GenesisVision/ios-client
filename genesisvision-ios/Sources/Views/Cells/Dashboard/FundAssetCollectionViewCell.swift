//
//  AssetCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 07.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct FundAssetCollectionViewCellViewModel {
    let assetModel: PlatformAsset?
}

extension FundAssetCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: FundAssetCollectionViewCell) {
        cell.configure(assetModel)
    }
}

class FundAssetCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
       didSet {
           logoImageView.roundCorners()
       }
    }
    @IBOutlet weak var symbolLabel: SubtitleLabel!
    @IBOutlet weak var percentLabel: TitleLabel!
    
    func configure(_ assetModel: PlatformAsset?) {
        if let logo = assetModel?.icon, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.isHidden = false
            logoImageView.image = #imageLiteral(resourceName: "img_wallet_usdt_icon")
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        } else {
            logoImageView.isHidden = true
        }
        if let symbol = assetModel?.asset {
            symbolLabel.text = symbol
            symbolLabel.isHidden = false
        } else {
            symbolLabel.isHidden = true
        }
        if let value = assetModel?.mandatoryFundPercent {
            percentLabel.text = value.toString() + " %"
            percentLabel.isHidden = false
        } else {
            percentLabel.isHidden = true
        }
        
        if assetModel?.icon == nil, assetModel?.asset == nil {
            percentLabel.textAlignment = .center
            percentLabel.textColor = UIColor.primary
        } else {
            percentLabel.textAlignment = .right
            percentLabel.textColor = UIColor.Cell.title
        }
    }
}
