//
//  NotificationsSettingsGeneralTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 18/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationsSettingsGeneralTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var settingsProtocol: NotificationsSettingsProtocol?
    
    var setting: NotificationSettingViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var enableSwitch: UISwitch! {
        didSet {
            enableSwitch.onTintColor = UIColor.primary
            enableSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            enableSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func changeSwitchAction(_ sender: UISwitch) {
        sender.isOn ? settingsProtocol?.didAdd(type: setting?.type) : settingsProtocol?.didRemove(settingId: setting?._id?.uuidString)
    }
}
