//
//  UIImage+Placeholder.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    static var placeholder: UIImage =  #imageLiteral(resourceName: "img_logo")
    static var programPlaceholder: UIImage =  #imageLiteral(resourceName: "img_program_placeholder")
    static var fundPlaceholder: UIImage =  #imageLiteral(resourceName: "img_program_placeholder")
    static var profilePlaceholder: UIImage =  #imageLiteral(resourceName: "img_manager_placeholder")
    static var eventPlaceholder: UIImage =  #imageLiteral(resourceName: "img_wallet_transaction_icon")
    
    static var noDataPlaceholder: UIImage = #imageLiteral(resourceName: "img_nodata_list")
    
    struct NavBar {
        static var ipfsList: UIImage = #imageLiteral(resourceName: "img_ipfs_list")
    }

    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

