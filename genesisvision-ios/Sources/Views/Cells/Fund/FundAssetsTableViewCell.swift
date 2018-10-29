//
//  FundAssetsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 29/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundAssetsTableViewCell: UITableViewCell {

    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var nameLabel: TitleLabel!
    
    @IBOutlet weak var assetLabel: SubtitleLabel!
    
    @IBOutlet weak var assetPercentLabel: TitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
