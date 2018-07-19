//
//  EditableField.swift
//  genesisvision-ios
//
//  Created by George on 12/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class EditableField<T> {
    var text: String
    var type: T
    var placeholder: String
    var editable: Bool
    var selectable: Bool
    var isSecureTextEntry: Bool
    var keyboardType: UIKeyboardType
    var returnKeyType: UIReturnKeyType
    var textContentType: UITextContentType?
    
    var isValid: (String) -> Bool
    
    init(text: String, placeholder: String, editable: Bool, selectable: Bool, isSecureTextEntry: Bool, type: T, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType, textContentType: UITextContentType?, isValid: @escaping (String) -> Bool) {
        self.text = text
        self.type = type
        self.placeholder = placeholder
        self.editable = editable
        self.selectable = selectable
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.textContentType = textContentType
        self.isValid = isValid
    }
}
