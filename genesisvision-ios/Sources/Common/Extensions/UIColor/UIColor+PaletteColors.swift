//
//  UIColor+PaletteColors.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    static var lightGray: UIColor  { return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) }                                   //efeff4
    
    static var colorPrimary: UIColor  { return #colorLiteral(red: 0.01176470588, green: 0.7411764706, blue: 0.6862745098, alpha: 1) }                                //03bdaf
    static var colorPrimaryDark: UIColor  { return #colorLiteral(red: 0.1647058824, green: 0.4549019608, blue: 0.5490196078, alpha: 1) }                            //2a748c
    static var colorAccent: UIColor  { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                                 //aab8c0
    
    static var colorFontDark: UIColor  { return  #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1) }                              //546e7a
    static var colorFontMedium: UIColor  { return #colorLiteral(red: 0.6666666667, green: 0.7215686275, blue: 0.7529411765, alpha: 1) }                             //aab8c0
    static var colorFontLight: UIColor  { return #colorLiteral(red: 0.8117647059, green: 0.8352941176, blue: 0.8549019608, alpha: 1) }                              //cfd5da
    
    static var colorGrayBackground: UIColor  { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) }                         //fafafa
    static var colorGrayDivider: UIColor  { return #colorLiteral(red: 0.8117647059, green: 0.8470588235, blue: 0.862745098, alpha: 1).withAlphaComponent(0.8) }    //cfd8dc
    static var colorAzure: UIColor  { return #colorLiteral(red: 0.1333333333, green: 0.8078431373, blue: 0.7529411765, alpha: 1) }                                  //22cec0
    static var colorAzureLight: UIColor  { return #colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 0.9294117647, alpha: 1) }                             //e5eeed
    
    static var whiteTransparent50: UIColor  { return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1).withAlphaComponent(0.5) }  //fafafa
    static var grey700: UIColor  { return #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1) }                                     //616161
    static var grey200: UIColor  { return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1) }                                     //eeeeee
    
    static var transactionGreen: UIColor  { return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1) }                            //4caf50
    static var transactionRed: UIColor  { return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1) }                              //f44336
}
