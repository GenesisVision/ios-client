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

    var valueChanged: ((String) -> Void)?
    
    // MARK: - Views
    @IBOutlet var textField: HoshiTextField! {
        didSet {
            textField.borderInactiveColor = UIColor.black
            textField.placeholderColor = UIColor.Font.dark
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
    @IBAction func descriptionTextViewChanged(_ sender: UITextField) {
        valueChanged?(sender.text ?? "")
    }
    
}
