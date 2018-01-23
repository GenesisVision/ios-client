//
//  Validation.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 23.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class Validation {
    
    struct ValidateField {
        let text: String
        let type: Validation.ValidationType
    }
    
    enum ValidationType: String {
        case mail = "Please enter the mail"
        case email = "Please enter the email"
        case password = "Please enter the password"
        case confirmPassword = "Please enter the password again"
    }
    
    static func isValid(value: String, type: ValidationType) -> (Bool, String) {
        return (enableCharacters(value), type.rawValue)
    }
    
    static func isValidError(with validateFields: [ValidateField]) -> String? {
        for validateField in validateFields {
            let validation = Validation.isValid(value: validateField.text, type: validateField.type)
            
            if !validation.0 {
                return validation.1
            }
        }
        
        return nil
    }
    
    // MARK: - Private
    
    private static func isMail(_ string: String) -> Bool {
        let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: string) && !string.contains("..") // NOT contains two dots in a row
    }
    
    private static func enableCharacters(_ string: String) -> Bool {
        return string.count > 0
    }
    
}
