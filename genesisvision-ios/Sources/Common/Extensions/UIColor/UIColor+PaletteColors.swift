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
        static var darkBlue: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                //28768D
        static var veryDarkBlue: UIColor { return  #colorLiteral(red: 0.1058823529, green: 0.3098039216, blue: 0.3921568627, alpha: 1) }                           //1B4F64
        
        static var dark: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                    //546e7a

        static var green: UIColor { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                                   //4caf50
        static var red: UIColor { return #colorLiteral(red: 0.8745098039, green: 0.09411764706, blue: 0.3960784314, alpha: 1) }                                     //df1865
        static var black: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                                   //f44336
        
//        static var lightGray: UIColor { return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) }                               //cfd8dc
        static var darkGray: UIColor { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                //aab8c0
        static var gray: UIColor { return #colorLiteral(red: 0.8117647059, green: 0.8352941176, blue: 0.8549019608, alpha: 1) }                                    //cfd5da
        static var sliderLineColor: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 1) }                         //e3ebed
        static var textFieldLineColor: UIColor { return #colorLiteral(red: 0.8, green: 0.8352941176, blue: 0.831372549, alpha: 1) }                      //ccd5d4
        
        static var lightGray: UIColor { return #colorLiteral(red: 0.9882352941, green: 0.9921568627, blue: 0.9921568627, alpha: 1) }                               //fcfdfd
        static var white: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                                   //ffffff
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
        static var programTitle: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }
        static var programStatus: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }
    }
    
    struct Header {
        static var darkTitle: UIColor { return Font.dark }
        static var darkSubtitle: UIColor { return Font.dark }
        static var graySubtitle: UIColor { return Common.sliderLineColor }
    }
    
    struct Font {
        static var primary: UIColor { return Common.primary }
        
        static var dark: UIColor { return  Common.veryDarkBlue }
        static var darkBlue: UIColor { return  Common.darkBlue }
        
        static var medium: UIColor { return Common.darkGray }
        static var light: UIColor { return Common.gray }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return Common.red }
        static var blue: UIColor { return Common.blue }
        
        static var black: UIColor { return Common.black }
        static var white: UIColor { return Common.white }
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
    
    struct TextField {
        static var line: UIColor { return Common.textFieldLineColor }
        static var empty: UIColor { return Common.textFieldLineColor }
        static var filled: UIColor { return Common.primary }
        static var placeholder: UIColor { return Common.veryDarkBlue }
    }
    
    struct TabBar {
        static var tint: UIColor { return Common.white }
        static var background: UIColor { return Common.primary }
        static var unselected: UIColor { return #colorLiteral(red: 0.7411764706, green: 0.9098039216, blue: 0.9019607843, alpha: 1) }
    }
    
    struct NavBar {
        static var tint: UIColor { return Common.primary }
        static var background: UIColor { return Common.white }
        static var grayBackground: UIColor { return #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) }
    }
    
    struct Border {
        static var forImage: UIColor { return UIColor.white }
    }
    
    struct Cell {
        static var separator: UIColor { return #colorLiteral(red: 0.4901960784, green: 0.5764705882, blue: 0.6, alpha: 0.5) }
    }
}
