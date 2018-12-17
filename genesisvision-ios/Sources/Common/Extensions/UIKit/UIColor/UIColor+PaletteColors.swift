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
    }
    
    struct Common {
        static var primary: UIColor { return #colorLiteral(red: 0, green: 0.7411764706, blue: 0.6862745098, alpha: 1) }                                 //00BDAF
        
        static var darkBackground: UIColor { return #colorLiteral(red: 0.07450980392, green: 0.1176470588, blue: 0.1490196078, alpha: 1) }                          //131E26
        static var darkCell: UIColor { return #colorLiteral(red: 0.1215686275, green: 0.168627451, blue: 0.2078431373, alpha: 1) }                                //1F2B35
        static var darkRatingCell: UIColor { return #colorLiteral(red: 0.09803921569, green: 0.1803921569, blue: 0.2470588235, alpha: 1) }                          //192E3F
        
        static var darkSectionHeader: UIColor { return #colorLiteral(red: 0.06666666667, green: 0.1019607843, blue: 0.1254901961, alpha: 1) }                       //111A20
        
        static var green: UIColor { return #colorLiteral(red: 0.1803921569, green: 0.7411764706, blue: 0.5215686275, alpha: 1) }                                   //2EBD85
        static var red: UIColor { return #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0.3529411765, alpha: 1) }                                     //EB3B5A
        static var redBg: UIColor { return #colorLiteral(red: 0.1960784314, green: 0.1725490196, blue: 0.2196078431, alpha: 1) }                                   //322C38
        
        static var lightChart: UIColor { return #colorLiteral(red: 0.5176470588, green: 0.8392156863, blue: 0.8156862745, alpha: 1) }                              //84D6D0
        static var darkChart: UIColor { return #colorLiteral(red: 0.1294117647, green: 0.2745098039, blue: 0.3137254902, alpha: 1) }                               //214650
        
        static var lightDelimiter: UIColor { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                          //fafafa
        
        static var darkDelimiter: UIColor { return #colorLiteral(red: 0.137254902, green: 0.168627451, blue: 0.1921568627, alpha: 1) }                           //232b31

        static var darkButtonBackground: UIColor { return #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                    //1B252C
        
        static var blackSeparator: UIColor { return #colorLiteral(red: 0.05490196078, green: 0.08235294118, blue: 0.09803921569, alpha: 1) }                          //0E1519
        
        static var darkTextPrimary: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                         //ffffff
        static var darkTextSecondary: UIColor { return #colorLiteral(red: 0.4705882353, green: 0.4901960784, blue: 0.5098039216, alpha: 1) }                       //787d82
        static var darkButtonText: UIColor { return #colorLiteral(red: 0.662745098, green: 0.6745098039, blue: 0.6901960784, alpha: 1) }                          //787d82
        static var darkTextPlaceholder: UIColor { return #colorLiteral(red: 0.4352941176, green: 0.462745098, blue: 0.4784313725, alpha: 1) }                     //6F767A
        
        static var lightBackground: UIColor { return #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1) }                         //f3f3f3
        static var lightCell: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                               //ffffff
        
        static var nodata: UIColor { return #colorLiteral(red: 0.3529411765, green: 0.3803921569, blue: 0.4039215686, alpha: 1) }                                  //5A6167
        
        static var lightTextPrimary: UIColor { return #colorLiteral(red: 0.1098039216, green: 0.137254902, blue: 0.1647058824, alpha: 1) }                        //1c232a
        static var lightTextSecondary: UIColor { return #colorLiteral(red: 0.7333333333, green: 0.7411764706, blue: 0.7490196078, alpha: 1) }                      //bbbdbf
        
        static var switchTint: UIColor { return #colorLiteral(red: 0.1843137255, green: 0.2745098039, blue: 0.2901960784, alpha: 1) }                              //2F464A

        
        static var yellow: UIColor { return #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1) }                                  //F5A623

        static var blue: UIColor { return #colorLiteral(red: 0.2039215686, green: 0.6509803922, blue: 0.7568627451, alpha: 1) }                                    //34A6C1
        
        static var purple: UIColor { return #colorLiteral(red: 0.3411764706, green: 0.3450980392, blue: 0.6470588235, alpha: 1) }                                  //5758A5

        static var powderPink: UIColor { return #colorLiteral(red: 1, green: 0.6470588235, blue: 0.8, alpha: 1) }                              //ffa5cc
        
        static var putty: UIColor { return #colorLiteral(red: 0.8078431373, green: 0.7725490196, blue: 0.6470588235, alpha: 1) }                                   //cec5a5
        static var puttyWithAlpha: UIColor { return #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.8941176471, alpha: 1) }                          //f0ede4
        
        static var black: UIColor { return #colorLiteral(red: 0.1254901961, green: 0.1450980392, blue: 0.1725490196, alpha: 1) }                                   //f44336
        
        static var darkGray: UIColor { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                //aab8c0
        static var paleGrey: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 1) }                                //e3ebed
        static var bgGray: UIColor { return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) }                                  //e0e0e0
        static var silver: UIColor { return #colorLiteral(red: 0.8, green: 0.8352941176, blue: 0.831372549, alpha: 1) }                                  //ccd5d4
        
        static var lightGray: UIColor { return #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1) }                               //FDFDFD
        static var white: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }                                   //ffffff
        
        static var numpadBackground: UIColor { return #colorLiteral(red: 0.8901960784, green: 0.9215686275, blue: 0.9294117647, alpha: 0.25) }
        static var numpadDotsBackground: UIColor { return #colorLiteral(red: 0.1647058824, green: 0.2, blue: 0.231372549, alpha: 1) }                   //2A333B
        static var unselected: UIColor { return #colorLiteral(red: 0.7411764706, green: 0.9098039216, blue: 0.9019607843, alpha: 1) }
        static var separator: UIColor { return #colorLiteral(red: 0.4901960784, green: 0.5764705882, blue: 0.6, alpha: 0.5) }
        
        static var usdColor: UIColor { return #colorLiteral(red: 0.5215686275, green: 0.7333333333, blue: 0.3960784314, alpha: 1) }                                //85bb65
        static var eurColor: UIColor { return #colorLiteral(red: 0, green: 0.2, blue: 0.6, alpha: 1) }                                //003399
        static var btcColor: UIColor { return #colorLiteral(red: 0.968627451, green: 0.5764705882, blue: 0.1019607843, alpha: 1) }                                //f7931a
        static var ethColor: UIColor { return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2392156863, alpha: 1) }                                //3C3C3D
        
        
        
        static var topaz: UIColor { return #colorLiteral(red: 0.08235294118, green: 0.7333333333, blue: 0.6862745098, alpha: 1) }                                   //15bbaf
        static var greenBlue: UIColor { return #colorLiteral(red: 0, green: 0.6705882353, blue: 0.6274509804, alpha: 1) }                               //00aba0
        
        static var uglyBlue: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.4666666667, blue: 0.5568627451, alpha: 1) }                                //25778E
        static var darkSlateBlue: UIColor { return #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.3960784314, alpha: 1) }                           //194f65
        
        static var dark: UIColor { return #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                                    //546e7a
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
        struct Filter {
            static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
            static var title: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.white }
            static var tint: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.white }
        }
    }
    
    struct Transaction {
        static var greenTransaction: UIColor { return Common.green }
        static var redTransaction: UIColor { return AppearanceController.theme == .darkTheme ? Common.red : Common.red }
        static var investType: UIColor { return Font.dark }
        static var currency: UIColor { return Font.medium }
        static var date: UIColor { return Font.medium }
        static var programTitle: UIColor { return Common.uglyBlue }
        static var programStatus: UIColor { return Common.uglyBlue }
    }
    
    struct Header {
        static var title: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.darkSlateBlue }
        static var subtitle: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.darkSlateBlue }
    }
    
    struct Font {
        static var primary: UIColor { return Common.primary }
        
        static var nodata: UIColor { return Common.nodata }
        static var dark: UIColor { return Common.darkSlateBlue }
        static var darkBlue: UIColor { return Common.uglyBlue }
        
        static var medium: UIColor { return Common.darkGray }
        static var light: UIColor { return Common.silver }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .darkTheme ? Common.red : Common.red }
        static var blue: UIColor { return Common.blue }
        
        static var black: UIColor { return Common.black }
        static var white: UIColor { return Common.white }
        
        static var numPadText: UIColor { return Common.lightDelimiter }
        static var amountDarkBlue: UIColor { return Common.darkSlateBlue }
        static var amountPlaceholder: UIColor { return Common.paleGrey }
    }
    
    struct Button {
        static var primary: UIColor { return Common.primary }
        static var darkBorder: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.dark }
        
        static var green: UIColor { return Common.green }
        static var red: UIColor { return AppearanceController.theme == .darkTheme ? Common.red : Common.red }
        
        static var gray: UIColor { return Common.silver }
        static var numpadBackground: UIColor { return Common.darkBackground }
    }
    
    struct Currency {
        static var eur: UIColor { return Common.eurColor }
        static var usd: UIColor { return Common.usdColor }
        
        static var eth: UIColor { return Common.btcColor }
        static var btc: UIColor { return Common.btcColor }
        static var gvt: UIColor { return Common.primary }
    }
    
    struct Slider {
        static var primary: UIColor { return Common.primary }
        static var line: UIColor { return Common.paleGrey }
        static var label: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.uglyBlue }
        static var title: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.darkSlateBlue }
        static var subTitle: UIColor { return AppearanceController.theme == .darkTheme ? GV.white : Common.uglyBlue }
    }
    
    struct ProgressView {
        static var progressTint: UIColor { return AppearanceController.theme == .darkTheme ? .primary : .primary }
        static var trackTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.lightDelimiter.withAlphaComponent(0.1) : Common.lightDelimiter.withAlphaComponent(0.1) }
    }
    
    struct DateRangeView {
        static var unselectedTitle: UIColor { return Common.darkButtonText }
        static var selectedTitle: UIColor { return Common.white }
        static var unselectedBg: UIColor { return Common.darkButtonBackground }
        static var selectedBg: UIColor { return Common.primary }
        static var textfieldBg: UIColor { return Common.darkBackground }
    }
    
    struct TextField {
        static var line: UIColor { return Common.silver }
        static var empty: UIColor { return Common.silver }
        static var filled: UIColor { return Common.primary }
        
        static var placeholder: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPlaceholder : Common.darkSlateBlue }
        static var title: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
    }
    
    struct TabBar {
        static var tint: UIColor { return AppearanceController.theme == .darkTheme ? Common.primary : Common.white }
        static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.primary }
        static var unselected: UIColor { return AppearanceController.theme == .darkTheme ? Common.white.withAlphaComponent(0.5) : Common.unselected }
    }
    
    struct NavBar {
        static func colorScheme(with style: NavBarType = .gray) -> NavBarColors {
            switch style {
            case .white:
                return NavBarColors(tintColor: Common.primary, backgroundColor: Common.white, textColor: Common.darkSlateBlue, subtitleColor: Common.darkGray)
            case .primary:
                return NavBarColors(tintColor: Common.white, backgroundColor: Common.primary, textColor: Common.white, subtitleColor: Common.white.withAlphaComponent(0.5))
            case .gray:
                return NavBarColors(tintColor: AppearanceController.theme == .darkTheme ? UIColor.Cell.title : Common.primary,
                                    backgroundColor: AppearanceController.theme == .darkTheme ? UIColor.BaseView.bg : Common.bgGray,
                                    textColor: AppearanceController.theme == .darkTheme ? UIColor.Cell.title : Common.darkSlateBlue,
                                    subtitleColor: AppearanceController.theme == .darkTheme ? UIColor.Cell.subtitle : Common.darkSlateBlue.withAlphaComponent(0.7))
            }
        }
    }
    
    struct InfoView {
        static var bg: UIColor { return Common.primary }
        static var text: UIColor { return Common.white }
        static var tint: UIColor { return Common.white }
    }
    
    struct Chart {
        static var light: UIColor { return Common.lightChart }
        static var middle: UIColor { return Common.primary }
        static var dark: UIColor { return Common.darkChart }
        
    }
    
    struct ChartCircle {
        static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.darkBackground }
        static var border: UIColor { return AppearanceController.theme == .darkTheme ? Common.lightDelimiter : Common.lightDelimiter }
    }
    
    
    struct ChartMarker {
        static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
        static var text: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkSlateBlue : Common.white }
    }
    
    struct BaseView {
        static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.bgGray }
        static var bottomGradientView: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkBackground : Common.white }
    }
    
    struct Border {
        static var forImage: UIColor { return Common.white }
        static var forButton: UIColor { return Common.lightDelimiter.withAlphaComponent(0.25) }
    }
    
    struct Cell {
        static var separator: UIColor { return Common.separator }
        static var bg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkCell : Common.white }
        static var ratingBg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkRatingCell : Common.white }
        static var selectedBg: UIColor { return AppearanceController.theme == .darkTheme ? Common.uglyBlue.withAlphaComponent(0.7) : Common.lightGray }
        static var headerBg: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkSectionHeader : Common.darkSectionHeader }
        
        static var title: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
        
        static var ratingTagTitle: UIColor { return Common.blue }
        static var ratingTagBg: UIColor { return Common.blue.withAlphaComponent(0.2) }
        
        static var redTitle: UIColor { return AppearanceController.theme == .darkTheme ? Common.red : Common.red }
        static var redBg: UIColor { return AppearanceController.theme == .darkTheme ? Common.redBg : Common.redBg }
        static var greenTitle: UIColor { return AppearanceController.theme == .darkTheme ? Common.green : Common.green }
        static var yellowTitle: UIColor { return AppearanceController.theme == .darkTheme ? Common.yellow : Common.yellow }
        static var blue: UIColor { return AppearanceController.theme == .darkTheme ? Common.blue : Common.blue }
        static var subtitle: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextSecondary : Common.darkSlateBlue }
        static var switchThumbTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.white : Common.white }
        static var switchTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.lightDelimiter.withAlphaComponent(0.25) : Common.switchTint }
    }
    
    struct TwoFactor {
        static var title: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.dark }
        static var codeTitle: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.primary }
        
        static var pageControllPageIndicatorTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
        static var pageControllCurrentPageIndicatorTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.primary : Common.primary }
        static var pageControllTint: UIColor { return AppearanceController.theme == .darkTheme ? Common.darkTextPrimary : Common.darkSlateBlue }
    }
    
    struct Level {
        static var first: UIColor { return #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.4039215686, alpha: 1) }                                    //373867
        static var second: UIColor { return #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.5647058824, alpha: 1) }                                   //4A5090
        static var third: UIColor { return #colorLiteral(red: 0.368627451, green: 0.4156862745, blue: 0.7450980392, alpha: 1) }                                    //5E6ABE
        static var fourth: UIColor { return #colorLiteral(red: 0.431372549, green: 0.5058823529, blue: 0.8862745098, alpha: 1) }                                   //6E81E2
        static var fifth: UIColor { return #colorLiteral(red: 0.3137254902, green: 0.5803921569, blue: 0.8196078431, alpha: 1) }                                    //5094D1
        static var sixth: UIColor { return Common.blue }
        static var seventh: UIColor { return #colorLiteral(red: 0.08235294118, green: 0.7333333333, blue: 0.6862745098, alpha: 1) }                                  //15BBAF
        
        static func color(for level: Int) -> UIColor {
            switch level {
            case 1:
                return Level.first
            case 2:
                return Level.second
            case 3:
                return Level.third
            case 4:
                return Level.fourth
            case 5:
                return Level.fifth
            case 6:
                return Level.sixth
            case 7:
                return Level.seventh
            default:
                return Level.first
            }
        }
    }
    
    struct Status {
        static var active: UIColor { return Common.white }
        static var ended: UIColor { return Common.white.withAlphaComponent(0.5) }
        static var investing: UIColor { return Common.yellow }
        static var withdrawing: UIColor { return #colorLiteral(red: 0.4352941176, green: 0.4980392157, blue: 0.8901960784, alpha: 1) }                               //6F7FE3
        
        static func colors(for status: String) -> (UIColor, UIColor) {
            switch status.capitalized {
            case "Investing":
                return (Status.investing, Status.investing.withAlphaComponent(0.1))
            case "Withdrawing":
                return (Status.withdrawing, Status.withdrawing.withAlphaComponent(0.1))
            case "Active":
                return (Status.active, Status.active.withAlphaComponent(0.1))
            case "Ended", "Closed":
                return (Status.ended, Status.ended.withAlphaComponent(0.1))
            default:
                return (Common.lightDelimiter, Common.darkCell)
            }
        }
    }
}
