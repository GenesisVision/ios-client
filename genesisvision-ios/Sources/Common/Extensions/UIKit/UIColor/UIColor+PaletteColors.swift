//
//  UIColor+PaletteColors.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    private struct GV {
        static var dark: UIColor { return #colorLiteral(red: 0.2274509804, green: 0.2431372549, blue: 0.2588235294, alpha: 1) }                                                                               //20252C
        static var white: UIColor { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                                                                              //FAFAFA
        static var red: UIColor { return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
    }
    
    private struct Common {
        static var primary: UIColor { return #colorLiteral(red: 0, green: 0.7411764706, blue: 0.6862745098, alpha: 1) }                                 //00BDAF
        static var blue: UIColor { return #colorLiteral(red: 0.2235294118, green: 0.6549019608, blue: 0.8588235294, alpha: 1) }                                    //39a7db
        static var darkBlue: UIColor { return #colorLiteral(red: 0.1568627451, green: 0.462745098, blue: 0.5529411765, alpha: 1) }                                //28768d
        static var veryDarkBlue: UIColor { return #colorLiteral(red: 0.1058823529, green: 0.3098039216, blue: 0.3921568627, alpha: 1) }                           //1B4F64
        
        static var dark: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                    //546e7a

        static var green: UIColor { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                                   //4caf50
        static var red: UIColor { return #colorLiteral(red: 0.8745098039, green: 0.09411764706, blue: 0.3960784314, alpha: 1) }                                     //df1865
        static var black: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                                   //f44336
        
        static var darkGray: UIColor { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                //aab8c0
        static var gray: UIColor { return #colorLiteral(red: 0.8117647059, green: 0.8352941176, blue: 0.8549019608, alpha: 1) }                                    //cfd5da
        static var placeholder: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 1) }                             //e3ebed
        static var bgGray: UIColor { return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) }                                  //e0e0e0
        static var textFieldLineColor: UIColor { return #colorLiteral(red: 0.8, green: 0.8352941176, blue: 0.831372549, alpha: 1) }                      //ccd5d4
        
        static var lightGray: UIColor { return #colorLiteral(red: 0.9882352941, green: 0.9921568627, blue: 0.9921568627, alpha: 1) }                               //fcfdfd
        static var white: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                                   //ffffff
        
        static var numPadText: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }                              //25778E
        static var amountDarkBlue: UIColor { return #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.3960784314, alpha: 1) }                          //194f65
        
        static var programTitle: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }
        static var programStatus: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }
        
        static var numpadBackground: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 0.25) }
        static var unselected: UIColor { return #colorLiteral(red: 0.7411764706, green: 0.9098039216, blue: 0.9019607843, alpha: 1) }
        static var separator: UIColor { return #colorLiteral(red: 0.4901960784, green: 0.5764705882, blue: 0.6, alpha: 0.5) }
    }
    
    static var primary: UIColor { return Common.primary }
    
    struct View {
        static var cell: UIColor { return Common.white }
        
        struct Background {
            static var main: UIColor { return Common.white }
            static var highlightedCell: UIColor { return Common.primary.withAlphaComponent(0.3) }
            static var primary: UIColor { return Common.primary }
            static var gray: UIColor { return Common.lightGray }
            static var darkGray: UIColor { return Common.bgGray }
        }
    }
        
    struct Background {
        static var main: UIColor { return Common.white }
        static var highlightedCell: UIColor { return Common.primary.withAlphaComponent(0.3) }
        static var primary: UIColor { return Common.primary }
        static var gray: UIColor { return Common.lightGray }
    }
    
    struct Transaction {
        static var greenTransaction: UIColor { return Common.green }
        static var redTransaction: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.red }
        static var investType: UIColor { return Font.dark }
        static var currency: UIColor { return Font.medium }
        static var date: UIColor { return Font.medium }
        static var programTitle: UIColor { return Common.programTitle }
        static var programStatus: UIColor { return Common.programStatus }
    }
    
    struct Header {
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.amountDarkBlue }
        static var subtitle: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.amountDarkBlue }
    }
    
    struct Font {
        static var primary: UIColor { return Common.primary }
        
        static var dark: UIColor { return Common.veryDarkBlue }
        static var darkBlue: UIColor { return Common.darkBlue }
        
        static var medium: UIColor { return Common.darkGray }
        static var light: UIColor { return Common.gray }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.red }
        static var blue: UIColor { return Common.blue }
        
        static var black: UIColor { return Common.black }
        static var white: UIColor { return Common.white }
        
        static var numPadText: UIColor { return Common.numPadText }
        static var amountDarkBlue: UIColor { return Common.amountDarkBlue }
        static var amountPlaceholder: UIColor { return Common.placeholder }
    }
    
    struct Button {
        static var primary: UIColor { return Common.primary }
        static var darkBorder: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.dark }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.red }
        
        static var gray: UIColor { return Common.gray }
        static var numpadBackground: UIColor { return Common.numpadBackground }
    }
    
    struct Slider {
        static var primary: UIColor { return Common.primary }
        static var line: UIColor { return Common.placeholder }
        static var label: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkBlue }
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.veryDarkBlue }
        static var subTitle: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkBlue }
    }
    
    struct TextField {
        static var line: UIColor { return Common.textFieldLineColor }
        static var empty: UIColor { return Common.textFieldLineColor }
        static var filled: UIColor { return Common.primary }
        static var placeholder: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.veryDarkBlue }
    }
    
    struct TabBar {
        static var tint: UIColor { return AppearanceController.theme == .dark ? Common.primary : Common.white }
        static var bg: UIColor { return AppearanceController.theme == .dark ? GV.dark : Common.primary }
        static var unselected: UIColor { return AppearanceController.theme == .dark ? Common.white.withAlphaComponent(0.5) : Common.unselected }
    }
    
    struct NavBar {
        static func colorScheme(with style: NavBarType = .gray) -> NavBarColors {
            switch style {
            case .white:
                return NavBarColors(tintColor: Common.primary, backgroundColor: Common.white, textColor: Common.veryDarkBlue, subtitleColor: Common.darkGray)
            case .primary:
                return NavBarColors(tintColor: Common.white, backgroundColor: Common.primary, textColor: Common.white, subtitleColor: Common.white.withAlphaComponent(0.5))
            case .gray:
                return NavBarColors(tintColor: Common.primary, backgroundColor: AppearanceController.theme == .dark ? GV.dark : Common.bgGray, textColor: AppearanceController.theme == .dark ? GV.white : Common.veryDarkBlue, subtitleColor: AppearanceController.theme == .dark ? GV.white.withAlphaComponent(0.7) : Common.veryDarkBlue.withAlphaComponent(0.7))
            }
        }
    }
    
    struct InfoView {
        static var bg: UIColor { return Common.primary }
        static var text: UIColor { return Common.white }
        static var tint: UIColor { return Common.white }
    }
    
    struct ChartMarker {
        static var bg: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.veryDarkBlue }
        static var text: UIColor { return AppearanceController.theme == .dark ? Common.veryDarkBlue : Common.white }
    }
    
    struct BaseView {
        static var bg: UIColor { return AppearanceController.theme == .dark ? GV.dark : Common.bgGray }
        static var bottomGradientView: UIColor { return AppearanceController.theme == .dark ? GV.dark : Common.white }
    }
    
    struct Border {
        static var forImage: UIColor { return UIColor.white }
    }
    
    struct Cell {
        static var separator: UIColor { return Common.separator }
        static var bg: UIColor { return AppearanceController.theme == .dark ? #colorLiteral(red: 0.2941176471, green: 0.3019607843, blue: 0.3137254902, alpha: 1) : Common.white }
        static var unableBg: UIColor { return AppearanceController.theme == .dark ? Common.darkBlue.withAlphaComponent(0.7) : Common.gray }
        static var selectedBg: UIColor { return AppearanceController.theme == .dark ? Common.darkBlue.withAlphaComponent(0.7) : Common.lightGray }
        
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.amountDarkBlue }
        static var redTitle: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.red }
        static var subtitle: UIColor { return Common.primary }
    }
}
