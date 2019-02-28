//
//  NotificationsSettingsAssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationsSettingsAssetTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var notificationsCountLabel: TitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
