//
//  UIFontExtension.swift
//  genesisvision-ios
//
//  Created by George on 19/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    static var boldName = "NeuzeitGro-Bol"
    static var regularName = "NeuzeitGro-Reg"
    static var semiBoldName = "NeuzeitGro-Bla"
    static var lightName = "NeuzeitGro-Lig"
    
    struct Common {
        static var bold: UIFont { return UIFont(name: boldName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold) }
        static var regular: UIFont { return UIFont(name: regularName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular) }
        static var semiBold: UIFont { return UIFont(name: semiBoldName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold) }
        static var light: UIFont { return UIFont(name: lightName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light) }
    }
    
    static func getFont(_ weight: Weight, size fontSize: CGFloat) -> UIFont {
        switch weight {
        case .light:
            return UIFont(name: UIFont.lightName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
        case .regular:
            return UIFont(name: UIFont.regularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        case .bold:
            return UIFont(name: UIFont.boldName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        case .semibold:
            return UIFont(name: UIFont.semiBoldName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        default:
            return UIFont(name: UIFont.regularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }
    }
}

