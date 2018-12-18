//
//  NotificationsSettingsGeneralTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct NotificationsSettingsGeneralTableViewCellViewModel {
    let setting: NotificationSettingViewModel
}

extension NotificationsSettingsGeneralTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationsSettingsGeneralTableViewCell) {
        if let type = setting.type {
            cell.titleLabel.text = type.rawValue
        }
        
        if let isEnabled = setting.isEnabled {
            cell.enableSwitch.isOn = isEnabled
        }
    }
}
