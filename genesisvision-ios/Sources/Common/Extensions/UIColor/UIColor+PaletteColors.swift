//
//  UIColor+PaletteColors.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    enum ColorType {
        case blue
    }
    
    convenience init(_ colorType: ColorType) {
        switch colorType {
        case .blue:
            self.init(red: 1, green: 189, blue: 174)
        }
    }
}

