//
//  ProfileFieldTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct ProfileFieldTableViewCellViewModel {
    var text: String
    var placeholder: String
    var editable: Bool
    var keyboardType: UIKeyboardType?
    var textContentType: UITextContentType?
    let valueChanged: ((String) -> Void)
}

extension ProfileFieldTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProfileFieldTableViewCell) {
        cell.textField.text = text
        cell.textField.placeholder = placeholder
        cell.textField.isUserInteractionEnabled = editable
        
        cell.textField.borderActiveColor = editable ? UIColor.primary : nil
        
        if let keyboardType = keyboardType {
            cell.textField.keyboardType = keyboardType
        }
        
        if let textContentType = textContentType {
            cell.textField.textContentType = textContentType
        }
        
        cell.valueChanged = valueChanged
    }
}
