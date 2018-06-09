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
        static var dark: UIColor { return #colorLiteral(red: 0.2274509804, green: 0.2431372549, blue: 0.2588235294, alpha: 1) }                                    //20252C
        static var white: UIColor { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                                   //FAFAFA
        static var red: UIColor { return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
    }
    
    private struct Common {
        static var primary: UIColor { return #colorLiteral(red: 0, green: 0.7411764706, blue: 0.6862745098, alpha: 1) }                                 //00BDAF
        static var topaz: UIColor { return #colorLiteral(red: 0.08235294118, green: 0.7333333333, blue: 0.6862745098, alpha: 1) }                                   //15bbaf
        static var greenBlue: UIColor { return #colorLiteral(red: 0, green: 0.6705882353, blue: 0.6274509804, alpha: 1) }                               //00aba0
        static var blue: UIColor { return #colorLiteral(red: 0.2235294118, green: 0.6549019608, blue: 0.8588235294, alpha: 1) }                                    //39a7db
        static var uglyBlue: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }                                //25778E
        static var darkSlateBlue: UIColor { return #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.3960784314, alpha: 1) }                           //194f65
        
        static var dark: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                    //546e7a

        static var green: UIColor { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                                   //4caf50
        static var lipstick: UIColor { return #colorLiteral(red: 0.8745098039, green: 0.09411764706, blue: 0.3960784314, alpha: 1) }                                //df1865
        static var powderPink: UIColor { return #colorLiteral(red: 1, green: 0.6470588235, blue: 0.8, alpha: 1) }                              //ffa5cc
        
        static var putty: UIColor { return #colorLiteral(red: 0.8078431373, green: 0.7725490196, blue: 0.6470588235, alpha: 1) }                                   //cec5a5
        static var puttyWithAlpha: UIColor { return #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.8941176471, alpha: 1) }                          //f0ede4
        
        static var black: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                                   //f44336
        
        static var darkGray: UIColor { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                //aab8c0
        static var paleGrey: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 1) }                                //e3ebed
        static var bgGray: UIColor { return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) }                                  //e0e0e0
        static var silver: UIColor { return #colorLiteral(red: 0.8, green: 0.8352941176, blue: 0.831372549, alpha: 1) }                                  //ccd5d4
        
        static var lightGray: UIColor { return #colorLiteral(red: 0.9882352941, green: 0.9921568627, blue: 0.9921568627, alpha: 1) }                               //fcfdfd
        static var white: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                                   //ffffff
        
        static var numpadBackground: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 0.25) }
        static var unselected: UIColor { return #colorLiteral(red: 0.7411764706, green: 0.9098039216, blue: 0.9019607843, alpha: 1) }
        static var separator: UIColor { return #colorLiteral(red: 0.4901960784, green: 0.5764705882, blue: 0.6, alpha: 0.5) }
        
        static var usdColor: UIColor { return #colorLiteral(red: 0.5215686275, green: 0.7333333333, blue: 0.3960784314, alpha: 1) }                                //85bb65
        static var eurColor: UIColor { return #colorLiteral(red: 0, green: 0.2, blue: 0.6, alpha: 1) }                                //003399
        static var btcColor: UIColor { return #colorLiteral(red: 0.968627451, green: 0.5764705882, blue: 0.1019607843, alpha: 1) }                                //f7931a
        static var ethColor: UIColor { return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2392156863, alpha: 1) }                                //3C3C3D
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
    
    struct BottomView {
        struct Sort {
            static var bg: UIColor { return Common.darkSlateBlue }
            static var title: UIColor { return Common.white }
            static var tint: UIColor { return Common.white }
        }
        
        struct Filter {
            static var bg: UIColor { return Common.darkSlateBlue }
            static var title: UIColor { return Common.white }
            static var tint: UIColor { return Common.white }
        }
    }
    
    struct Transaction {
        static var greenTransaction: UIColor { return Common.green }
        static var redTransaction: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.lipstick }
        static var investType: UIColor { return Font.dark }
        static var currency: UIColor { return Font.medium }
        static var date: UIColor { return Font.medium }
        static var programTitle: UIColor { return Common.uglyBlue }
        static var programStatus: UIColor { return Common.uglyBlue }
    }
    
    struct Header {
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
        static var subtitle: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
    }
    
    struct Font {
        static var primary: UIColor { return Common.primary }
        
        static var dark: UIColor { return Common.darkSlateBlue }
        static var darkBlue: UIColor { return Common.uglyBlue }
        
        static var medium: UIColor { return Common.darkGray }
        static var light: UIColor { return Common.silver }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.lipstick }
        static var blue: UIColor { return Common.blue }
        
        static var black: UIColor { return Common.black }
        static var white: UIColor { return Common.white }
        
        static var numPadText: UIColor { return Common.uglyBlue }
        static var amountDarkBlue: UIColor { return Common.darkSlateBlue }
        static var amountPlaceholder: UIColor { return Common.paleGrey }
    }
    
    struct Button {
        static var primary: UIColor { return Common.primary }
        static var darkBorder: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.dark }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.lipstick }
        
        static var gray: UIColor { return Common.silver }
        static var numpadBackground: UIColor { return Common.numpadBackground }
    }
    
    struct Currency {
        static var eur: UIColor { return Common.eurColor }
        static var usd: UIColor { return Common.usdColor }
        
        static var eth: UIColor { return Common.ethColor }
        static var btc: UIColor { return Common.btcColor }
        static var gvt: UIColor { return Common.primary }
    }
    
    struct Slider {
        static var primary: UIColor { return Common.primary }
        static var line: UIColor { return Common.paleGrey }
        static var label: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.uglyBlue }
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
        static var subTitle: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.uglyBlue }
    }
    
    struct TextField {
        static var line: UIColor { return Common.silver }
        static var empty: UIColor { return Common.silver }
        static var filled: UIColor { return Common.primary }
        static var placeholder: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
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
                return NavBarColors(tintColor: Common.primary, backgroundColor: Common.white, textColor: Common.darkSlateBlue, subtitleColor: Common.darkGray)
            case .primary:
                return NavBarColors(tintColor: Common.white, backgroundColor: Common.primary, textColor: Common.white, subtitleColor: Common.white.withAlphaComponent(0.5))
            case .gray:
                return NavBarColors(tintColor: Common.primary, backgroundColor: AppearanceController.theme == .dark ? GV.dark : Common.bgGray, textColor: AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue, subtitleColor: AppearanceController.theme == .dark ? GV.white.withAlphaComponent(0.7) : Common.darkSlateBlue.withAlphaComponent(0.7))
            }
        }
    }
    
    struct InfoView {
        static var bg: UIColor { return Common.primary }
        static var text: UIColor { return Common.white }
        static var tint: UIColor { return Common.white }
    }
    
    struct ChartMarker {
        static var bg: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
        static var text: UIColor { return AppearanceController.theme == .dark ? Common.darkSlateBlue : Common.white }
    }
    
    struct BaseView {
        static var bg: UIColor { return AppearanceController.theme == .dark ? GV.dark : Common.bgGray }
        static var bottomGradientView: UIColor { return AppearanceController.theme == .dark ? GV.dark : Common.white }
    }
    
    struct Border {
        static var forImage: UIColor { return Common.white }
    }
    
    struct Tournament {
        static var bg: UIColor { return Common.putty }
    }
    
    struct Cell {
        static var separator: UIColor { return Common.separator }
        static var bg: UIColor { return AppearanceController.theme == .dark ? #colorLiteral(red: 0.2941176471, green: 0.3019607843, blue: 0.3137254902, alpha: 1) : Common.white }
        static var tournamentBg: UIColor { return Common.puttyWithAlpha }
        static var selectedBg: UIColor { return AppearanceController.theme == .dark ? Common.uglyBlue.withAlphaComponent(0.7) : Common.lightGray }
        
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
        static var redTitle: UIColor { return AppearanceController.theme == .dark ? GV.red : Common.lipstick }
        static var subtitle: UIColor { return Common.primary }
    }
    
    struct TwoFactor {
        static var title: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.dark }
        static var codeTitle: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.primary }
        
        static var pageControllPageIndicatorTint: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
        static var pageControllCurrentPageIndicatorTint: UIColor { return AppearanceController.theme == .dark ? Common.primary : Common.primary }
        static var pageControllTint: UIColor { return AppearanceController.theme == .dark ? GV.white : Common.darkSlateBlue }
    }
}
