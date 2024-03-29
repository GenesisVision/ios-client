//
//  UIViewExtension.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView
import PKHUD

extension UIView {
    func roundCorners() {
        roundCorners(with: frame.height / 2)
    }
    
    func roundCorners(with radius: CGFloat) {
//        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func roundCorners(with radius: CGFloat? = nil, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
//        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        layer.cornerRadius = radius ?? frame.height / 2
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {   
            layer.borderWidth = borderWidth
        }
        layer.masksToBounds = true
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
    
    // MARK: - PKHUD
    func showProgressHUD(onView: UIView? = nil, withBgView: Bool = false) {
        PKHUD.sharedHUD.dimsBackground = withBgView
        HUD.show(.progress, onView: onView ?? self)
    }
    
    func hideHUD() {
        HUD.hide()
    }
    
    func showErrorHUD(subtitle: String? = nil) {
        notificationFeedback(style: .warning)
        subtitle != nil
            ? HUD.flash(.labeledError(title: nil, subtitle: subtitle), onView: self, delay: Constants.HudDelay.error)
            : HUD.flash(.error, onView: self, delay: Constants.HudDelay.error)
    }
    
    func showSuccessHUD(title: String? = nil, subtitle: String? = nil, completion: ((Bool) -> Void)? = nil) {
        title != nil || subtitle != nil
            ? HUD.flash(.labeledSuccess(title: title, subtitle: subtitle), onView: self, delay: Constants.HudDelay.success, completion: completion)
            : HUD.flash(.success, onView: self, delay: Constants.HudDelay.success, completion: completion)
    }
    
    func showHUD(type: HUDContentType) {
        HUD.show(.success, onView: self)
    }
    
    func showFlashHUD(type: HUDContentType, delay: TimeInterval? = nil) {
        HUD.flash(type, onView: self, delay: delay ?? Constants.HudDelay.default)
    }
    
    func typedSuperview<T: UIView>() -> T? {
        var parent = superview
        
        while parent != nil {
            if let view = parent as? T {
                return view
            } else {
                parent = parent?.superview
            }
        }
        
        return nil
    }
}

// MARK: Constraints extensions

extension UIView {
    
    func fillSuperview(padding: UIEdgeInsets) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
    
    func fillSuperview() {
        fillSuperview(padding: .zero)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorSize(size: CGSize) {
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorCenter(centerY: NSLayoutYAxisAnchor?, centerX: NSLayoutXAxisAnchor?) {
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
    }
}

extension UIView {
    
    enum BorderSide {
        case top
        case bottom
        case left
        case right
    }
    
    func addBorderLine(color: UIColor, borderWidth: CGFloat, side: BorderSide, padding: UIEdgeInsets? = nil) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .top:
            border.frame = CGRect(x: padding?.left ?? 0, y: 0, width: self.frame.size.width - ((padding?.right ?? 0) + (padding?.left ?? 0)), height: borderWidth)
        case .bottom:
            border.frame = CGRect(x: padding?.left ?? 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width - ((padding?.right ?? 0) + (padding?.left ?? 0)), height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: padding?.top ?? 0, width: borderWidth, height: self.frame.size.height - ((padding?.top ?? 0) + (padding?.bottom ?? 0)))
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: padding?.top ?? 0, width: borderWidth, height: self.frame.size.height - ((padding?.top ?? 0) + (padding?.bottom ?? 0)))
        }
        layer.addSublayer(border)
    }
}
