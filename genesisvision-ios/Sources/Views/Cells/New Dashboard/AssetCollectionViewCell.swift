//
//  AssetCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 07.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct AssetCollectionViewCellViewModel {
    let assetModel: AssetModel?
}

extension AssetCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: AssetCollectionViewCell) {
        cell.configure(assetModel)
    }
}

class AssetCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
       didSet {
           logoImageView.roundCorners()
       }
    }
    @IBOutlet weak var symbolLabel: SubtitleLabel!
    @IBOutlet weak var percentLabel: TitleLabel!
    
    func configure(_ assetModel: AssetModel?) {
        if let logo = assetModel?.logo, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.isHidden = false
            logoImageView.image = #imageLiteral(resourceName: "img_wallet_usdt_icon")
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        } else {
            logoImageView.isHidden = true
        }
        if let symbol = assetModel?.symbol {
            symbolLabel.text = symbol
            symbolLabel.isHidden = false
        } else {
            symbolLabel.isHidden = true
        }
        if let value = assetModel?.value {
            percentLabel.text = value.toString() + " %"
            percentLabel.isHidden = false
        } else {
            percentLabel.isHidden = true
        }
        
        if assetModel?.logo == nil, assetModel?.symbol == nil {
            percentLabel.textAlignment = .center
            percentLabel.textColor = UIColor.primary
        } else {
            percentLabel.textAlignment = .right
            percentLabel.textColor = UIColor.Cell.title
        }
    }
}
