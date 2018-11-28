//
//  FieldWithTextViewTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 12/07/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct FieldWithTextViewTableViewCellViewModel {
    var text: String
    var placeholder: String
    var editable: Bool
    var selectable: Bool
    var showAccessory: Bool
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    let valueChanged: ((String) -> Void)
}

extension FieldWithTextViewTableViewCellViewModel: CellViewModel {
    func setup(on cell: FieldWithTextViewTableViewCell) {
        cell.titleLabel.text = placeholder.uppercased()
        cell.textView.text = text

        cell.textView.isUserInteractionEnabled = editable
        cell.selectionStyle = selectable ? .default : .none
        
        cell.accessoryImageView.isHidden = !(showAccessory && (editable || selectable))
        cell.accessoryImageView.image = selectable ? #imageLiteral(resourceName: "img_dropdown_icon") : #imageLiteral(resourceName: "img_profile_edit")

        cell.textView.keyboardType = keyboardType
        cell.textView.returnKeyType = returnKeyType
        
        if let textContentType = textContentType {
            cell.textView.textContentType = textContentType
        }
        
        cell.valueChanged = valueChanged
    }
}
