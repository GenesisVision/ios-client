//
//  UIColor+PaletteColors.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    private struct Common {
        static var primary: UIColor { return #colorLiteral(red: 0.08235294118, green: 0.7333333333, blue: 0.6862745098, alpha: 1) }                                 //15bbaf
        static var blue: UIColor { return #colorLiteral(red: 0.2235294118, green: 0.6549019608, blue: 0.8588235294, alpha: 1) }                                    //39a7db
        static var darkBlue: UIColor { return #colorLiteral(red: 0.1568627451, green: 0.462745098, blue: 0.5529411765, alpha: 1) }                                //28768D
        static var veryDarkBlue: UIColor { return  #colorLiteral(red: 0.1058823529, green: 0.3098039216, blue: 0.3921568627, alpha: 1) }                           //1B4F64
        
        static var dark: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                    //546e7a

        static var green: UIColor { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                                   //4caf50
        static var red: UIColor { return #colorLiteral(red: 0.8745098039, green: 0.09411764706, blue: 0.3960784314, alpha: 1) }                                     //df1865
        static var black: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                                   //f44336
        
        static var lightGray: UIColor { return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) }                               //cfd8dc
        static var darkGray: UIColor { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                //aab8c0
        static var gray: UIColor { return #colorLiteral(red: 0.8117647059, green: 0.8352941176, blue: 0.8549019608, alpha: 1) }                                    //cfd5da
        static var sliderLineColor: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 1) }                         //e3ebed
        
        static var white: UIColor { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                                   //cfd8dc
    }
    
    static var primary: UIColor { return Common.primary }
    static var darkPrimary: UIColor { return Common.darkBlue }
    
    struct Background {
        static var main: UIColor { return Common.white }
        static var gray: UIColor { return Common.lightGray }
    }
    struct Transaction {
        static var greenTransaction: UIColor { return Common.green }
        static var redTransaction: UIColor { return Common.red }
        static var investType: UIColor { return Font.dark }
        static var currency: UIColor { return Font.medium }
        static var date: UIColor { return Font.medium }
    }
    
    struct Wallet {
        static var balance: UIColor { return Font.dark }
        static var usdBalance: UIColor { return Font.light }
        static var currency: UIColor { return primary }
    }
    
    struct Font {
        static var primary: UIColor { return Common     .primary }
        
        static var dark: UIColor { return  Common.dark }
        static var medium: UIColor { return Common.darkGray }
        static var light: UIColor { return Common.gray }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return Common.red }
        static var blue: UIColor { return Common.blue }
        
        static var black: UIColor { return Common.black }
    }
    
    struct Button {
        static var primary: UIColor { return Common.primary }
        static var darkBorder: UIColor { return Common.dark }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return Common.red }
        
        static var gray: UIColor { return Common.gray }
    }
    
    struct Slider {
        static var primary: UIColor { return Common.primary }
        static var line: UIColor { return Common.sliderLineColor }
        static var label: UIColor { return Common.darkBlue }
        static var title: UIColor { return Common.veryDarkBlue }
        static var subTitle: UIColor { return Common.darkBlue }
    }
    
    struct Border {
        static var forImage: UIColor { return UIColor.white }
    }
}
