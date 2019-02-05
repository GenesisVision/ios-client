//
//  FieldWithTextFieldTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04/02/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct FieldWithTextFieldTableViewCellViewModel {
    var text: String
    var placeholder: String
    var editable: Bool
    var selectable: Bool
    var showAccessory: Bool
    var isSecureTextEntry: Bool
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    weak var delegate: UITextFieldDelegate?
    let valueChanged: ((String) -> Void)
}

extension FieldWithTextFieldTableViewCellViewModel: CellViewModel {
    func setup(on cell: FieldWithTextFieldTableViewCell) {
        cell.titleLabel.text = placeholder.uppercased()
        cell.textField.text = text
        cell.textField.placeholder = placeholder
        cell.textField.isUserInteractionEnabled = editable
        cell.selectionStyle = selectable ? .default : .none
        
        cell.accessoryImageView.isHidden = !(showAccessory && (editable || selectable))
        cell.accessoryImageView.image = selectable ? #imageLiteral(resourceName: "img_dropdown_icon") : #imageLiteral(resourceName: "img_profile_edit")

        cell.textField.keyboardType = keyboardType
        
        if let textContentType = textContentType {
            cell.textField.textContentType = textContentType
        }
        
        cell.textField.delegate = delegate
        
        cell.textField.isSecureTextEntry = isSecureTextEntry
        cell.textField.returnKeyType = returnKeyType
        
        cell.valueChanged = valueChanged
    }
}
