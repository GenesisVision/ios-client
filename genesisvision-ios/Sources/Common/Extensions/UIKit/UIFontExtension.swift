//
//  UIFontExtension.swift
//  genesisvision-ios
//
//  Created by George on 19/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    static var boldName = "Montserrat-Bold"
    static var regularName = "Montserrat-Regular"
    static var mediumName = "Montserrat-Medium"
    static var semiBoldName = "Montserrat-SemiBold"
    static var lightName = "Montserrat-Light"
    
    static func getFont(_ weight: Weight, size fontSize: CGFloat) -> UIFont {
        switch weight {
        case .light:
            return UIFont(name: UIFont.lightName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
        case .regular:
            return UIFont(name: UIFont.regularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        case .medium:
            return UIFont(name: UIFont.mediumName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
        case .bold:
            return UIFont(name: UIFont.boldName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        case .semibold:
            return UIFont(name: UIFont.semiBoldName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        default:
            return UIFont(name: UIFont.regularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }
    }
}

