//
//  ProfileFieldTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileFieldTableViewCell: UITableViewCell {

    var valueChanged: ((String) -> Void)?
    
    // MARK: - Views
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var accessoryImageView: UIImageView!
    
    @IBOutlet var textField: DesignableUITextField! {
        didSet {
            textField.setClearButtonWhileEditing()
            textField.designableTextFieldDelegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryImageView.isHidden = true
        backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
    @IBAction func descriptionTextViewChanged(_ sender: UITextField) {
        valueChanged?(sender.text ?? "")
    }
}

extension ProfileFieldTableViewCell: DesignableUITextFieldDelegate {
    func textFieldDidClear() {
        valueChanged?("")
    }
}
