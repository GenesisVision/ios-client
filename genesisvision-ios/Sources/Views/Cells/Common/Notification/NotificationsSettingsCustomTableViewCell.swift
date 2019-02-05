//
//  NotificationsSettingsCustomTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 25/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationsSettingsCustomTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    weak var settingsProtocol: NotificationsSettingsProtocol?
    
    var setting: NotificationSettingViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.textColor = .primary
            subtitleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var enableSettingSwitchButton: UIButton! {
        didSet {
            enableSettingSwitchButton.setImage(#imageLiteral(resourceName: "img_checkbox_unselected_icon"), for: .normal)
            enableSettingSwitchButton.setImage(#imageLiteral(resourceName: "img_checkbox_selected_icon"), for: .selected)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func switchButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        settingsProtocol?.didChange(enable: sender.isSelected, settingId: setting?.id?.uuidString)
    }
}
