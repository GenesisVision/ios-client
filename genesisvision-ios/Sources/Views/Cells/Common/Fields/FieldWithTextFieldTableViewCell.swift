//
//  FieldWithTextFieldTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FieldWithTextFieldTableViewCell: PlateTableViewCell {

    var valueChanged: ((String) -> Void)?
    
    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    @IBOutlet weak var textField: DesignableUITextField! {
        didSet {
            textField.setClearButtonWhileEditing()
            textField.designableTextFieldDelegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryImageView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    @IBAction func descriptionTextViewChanged(_ sender: UITextField) {
        valueChanged?(sender.text ?? "")
    }
}

extension FieldWithTextFieldTableViewCell: DesignableUITextFieldDelegate {
    func textFieldDidClear() {
        valueChanged?("")
    }
}
