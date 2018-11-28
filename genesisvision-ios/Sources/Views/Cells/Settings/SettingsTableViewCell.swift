//
//  SettingsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 22/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewCell

class SettingsTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.Cell.bg
        contentView.backgroundColor = UIColor.Cell.bg
    }
}
