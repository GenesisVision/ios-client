//
//  UIViewExtension.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView

extension UIView {
    func roundCorners() {
        roundCorners(with: frame.height / 2)
    }
    
    func roundCorners(with radius: CGFloat) {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func roundWithBorder(_ approximateBorderWidth: CGFloat, color: UIColor = .white) {
        roundCorners()
        let border = makeRoundBorder(approximateBorderWidth, color: color)
        //TODO: Remove old border
        layer.addSublayer(border)
    }
    
    func addBorder(withBorderWidth borderWidth: CGFloat, color: UIColor = .white) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    fileprivate func makeRoundBorder(_ approximateBorderWidth: CGFloat, color: UIColor) -> CAShapeLayer {
        let border = CAShapeLayer()
        border.strokeColor = color.cgColor
        border.fillColor = UIColor.clear.cgColor
        border.frame = bounds
        border.lineWidth = (approximateBorderWidth * 2.0).rounded()
        border.path = UIBezierPath(ovalIn: border.bounds).cgPath
        
        return border
    }
}
