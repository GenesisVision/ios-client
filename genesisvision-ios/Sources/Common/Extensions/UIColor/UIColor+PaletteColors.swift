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
        static var blue: UIColor  { return #colorLiteral(red: 0.01176470588, green: 0.7411764706, blue: 0.6862745098, alpha: 1) }                                    //03bdaf
        static var dark: UIColor  { return  #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                   //546e7a
        static var green: UIColor  { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                                   //4caf50
        static var red: UIColor  { return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1) }                                     //f44336
    }
    
    static var lightGray: UIColor  { return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) }                                   //efeff4
    
    static var primary: UIColor  { return Common.blue }
    static var darkPrimary: UIColor  { return #colorLiteral(red: 0.1647058824, green: 0.4549019608, blue: 0.5490196078, alpha: 1) }                                 //2a748c
    static var accent: UIColor  { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                      //aab8c0
    
    static var lightBackground: UIColor  { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                             //fafafa
    static var background: UIColor  { return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) }                                  //cfd8dc
    static var azure: UIColor  { return #colorLiteral(red: 0.1333333333, green: 0.8078431373, blue: 0.7529411765, alpha: 1) }                                       //22cec0
    static var azureLight: UIColor  { return #colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 0.9294117647, alpha: 1) }                                  //e5eeed
    
    static var whiteTransparent50: UIColor  { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1).withAlphaComponent(0.5) }  //fafafa
    static var grey700: UIColor  { return #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1) }                                     //616161
    static var grey200: UIColor  { return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1) }                                     //eeeeee
    
    struct Transaction {
        static var greenTransaction: UIColor  { return Common.green }
        static var redTransaction: UIColor  { return Common.red }
        static var investType: UIColor  { return Font.dark }
        static var currency: UIColor  { return Font.medium }
        static var date: UIColor  { return Font.medium }
    }
    
    struct Wallet {
        static var balance: UIColor  { return Font.dark }
        static var currency: UIColor  { return primary }
    }
    
    struct Font {
        static var dark: UIColor  { return  Common.dark }
        static var medium: UIColor  { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                  //aab8c0
        static var light: UIColor  { return #colorLiteral(red: 0.8117647059, green: 0.8352941176, blue: 0.8549019608, alpha: 1) }                                   //cfd5da
        
        static var green: UIColor  { return Common.green }
        static var red: UIColor  { return Common.red }
    }
    
    struct Button {
        static var primary: UIColor  { return Common.blue }
        static var darkBorder: UIColor  { return Common.dark }
    }
}
