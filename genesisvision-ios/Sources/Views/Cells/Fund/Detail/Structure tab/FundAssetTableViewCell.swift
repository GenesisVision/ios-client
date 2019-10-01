//
//  FundAssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 29/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundAssetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var nameLabel: TitleLabel! {
        didSet {
            nameLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var assetLabel: SubtitleLabel! {
        didSet {
            assetLabel.font = UIFont.getFont(.regular, size: 13.0)
        }
    }
    
    @IBOutlet weak var targetPercentLabel: TitleLabel! {
        didSet {
            targetPercentLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var currentPercentLabel: TitleLabel! {
        didSet {
            currentPercentLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
