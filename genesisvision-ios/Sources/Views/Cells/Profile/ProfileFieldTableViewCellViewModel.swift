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
    var selectable: Bool
    var keyboardType: UIKeyboardType?
    var textContentType: UITextContentType?
    weak var delegate: UITextFieldDelegate?
    let valueChanged: ((String) -> Void)
}

extension ProfileFieldTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProfileFieldTableViewCell) {
        cell.titleLabel.text = placeholder.uppercased()
        cell.textField.text = text
        cell.textField.placeholder = placeholder
        cell.textField.isUserInteractionEnabled = editable
        cell.selectionStyle = selectable ? .default : .none
        
        if let keyboardType = keyboardType {
            cell.textField.keyboardType = keyboardType
        }
        
        if let textContentType = textContentType {
            cell.textField.textContentType = textContentType
        }
        
        cell.textField.delegate = delegate
        
        cell.valueChanged = valueChanged
    }
}
