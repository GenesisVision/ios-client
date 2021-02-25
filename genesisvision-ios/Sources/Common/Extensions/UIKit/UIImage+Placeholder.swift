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
    static var walletPlaceholder: UIImage =  #imageLiteral(resourceName: "img_wallet_gvt_icon")
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
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

