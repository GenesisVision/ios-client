//
//  NotificationsSettingsManagerTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct NotificationsSettingsManagerTableViewCellViewModel {
    let setting: ManagerNotificationSettingList
}

extension NotificationsSettingsManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationsSettingsAssetTableViewCell) {
        if let username = setting.username {
            cell.titleLabel.text = username
        }
        
        cell.assetLogoImageView.levelButton.isHidden = true
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = setting.avatar, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        var count = 0
        
        if let settingsGeneral = setting.settingsGeneral {
            count += settingsGeneral.count
        }
        
        cell.notificationsCountLabel.text = "\(count)"
    }
}
