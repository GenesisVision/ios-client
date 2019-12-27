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
    weak var settingsProtocol: NotificationsSettingsProtocol?
}

extension NotificationsSettingsGeneralTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationsSettingsGeneralTableViewCell) {
        cell.settingsProtocol = settingsProtocol
        
        cell.setting = setting
        
        if let type = setting.type {
            switch type {
            case .fundNewsAndUpdates:
                cell.titleLabel.text = "Fund news and updates"
            case .fundRebalancing:
                cell.titleLabel.text = "Fund rebalancing"
                
            case .programEndOfPeriod:
                cell.titleLabel.text = "End of the period"
            case .programNewsAndUpdates:
                cell.titleLabel.text = "Program news and updates"
                
            case .platformNewsAndUpdates:
                cell.titleLabel.text = "News and updates"
            case .platformEmergency:
                cell.titleLabel.text = "Emergency notifications"
                
            default:
                break
            }
        }
        
        if let isEnabled = setting.isEnabled {
            cell.enableSwitch.isOn = isEnabled
        }
    }
}
