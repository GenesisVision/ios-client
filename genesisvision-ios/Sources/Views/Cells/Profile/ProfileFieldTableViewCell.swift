//
//  ProfileFieldTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TextFieldEffects

class ProfileFieldTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var textField: HoshiTextField! {
        didSet {
            textField.borderActiveColor = UIColor.primary
            textField.borderInactiveColor = UIColor.black
            textField.placeholderColor = UIColor.Font.dark
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.background
        selectionStyle = .none
    }
    
}
