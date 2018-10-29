//
//  FundAssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 29/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct FundAssetTableViewCellViewModel {
    let fundAssetInfo: FundAssetInfo
}

extension FundAssetTableViewCellViewModel: CellViewModel {
    func setup(on cell: FundAssetTableViewCell) {
        cell.assetLogoImageView.image = nil
        
        if let icon = fundAssetInfo.icon, let fileUrl = getFileURL(fileName: icon) {
            cell.assetLogoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
        }
        
        if let name = fundAssetInfo.name {
            cell.nameLabel.text = name
        } else {
            cell.nameLabel.text = ""
        }
        
        if let asset = fundAssetInfo.asset {
            cell.assetLabel.text = "(\(asset))"
        } else {
            cell.assetLabel.text = ""
        }
        
        if let targetPercent = fundAssetInfo.targetPercent {
            cell.assetPercentLabel.text = targetPercent.rounded(withType: .undefined).toString() + "%"
        } else {
            cell.assetPercentLabel.text = ""
        }
    }
}

