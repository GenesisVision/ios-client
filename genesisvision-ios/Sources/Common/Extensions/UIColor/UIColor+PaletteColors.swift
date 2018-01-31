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
        case blue       //main color
        case lightGray  //background
        case darkGray   //text color
    }
    
    convenience init(_ colorType: ColorType) {
        switch colorType {
        case .blue:
            self.init(red: 1, green: 189, blue: 174)
        case .lightGray:
            self.init(red: 239, green: 239, blue: 244)
        case .darkGray:
            self.init(red: 87, green: 101, blue: 118)
        }
    }
}

