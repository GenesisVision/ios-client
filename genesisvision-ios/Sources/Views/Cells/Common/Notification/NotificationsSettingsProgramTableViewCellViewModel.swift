//
//  NotificationsSettingsProgramTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 17/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct NotificationsSettingsProgramTableViewCellViewModel {
    let setting: ProgramNotificationSettingList
}

extension NotificationsSettingsProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationsSettingsAssetTableViewCell) {
        if let title = setting.title {
            cell.titleLabel.text = title
        }

        if let level = setting.level {
            cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let levelProgress = setting.levelProgress {
            cell.assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let color = setting.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = setting.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        var count = 0
        
        if let settingsCustom = setting.settingsCustom {
            count += settingsCustom.count
        }
        if let settingsGeneral = setting.settingsGeneral {
            count += settingsGeneral.count
        }
        
        cell.notificationsCountLabel.text = "\(count)"
    }
}
