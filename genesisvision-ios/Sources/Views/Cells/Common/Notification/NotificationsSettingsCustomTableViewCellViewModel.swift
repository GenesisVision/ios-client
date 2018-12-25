//
//  NotificationsSettingsCustomTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct NotificationsSettingsCustomTableViewCellViewModel {
    let setting: NotificationSettingViewModel
    weak var settingsProtocol: NotificationsSettingsProtocol?
}

extension NotificationsSettingsCustomTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationsSettingsCustomTableViewCell) {
        cell.settingsProtocol = settingsProtocol
        
        cell.setting = setting
        
        if let conditionType = setting.conditionType {
            cell.titleLabel.text = conditionType.rawValue
            
            if let conditionAmount = setting.conditionAmount {
                cell.subtitleLabel.text = conditionAmount.toString()
                if conditionType == .profit {
                    cell.subtitleLabel.text?.append(" %")
                }
            }
        }
        
        if let isEnabled = setting.isEnabled {
            cell.enableSettingSwitchButton.isSelected = isEnabled
        }
    }
}
