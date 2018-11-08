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
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func roundCorners(with radius: CGFloat? = nil, borderWidth: CGFloat, borderColor: UIColor) {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        layer.cornerRadius = radius ?? frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
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
            ? HUD.flash(.labeledError(title: nil, subtitle: subtitle), onView: self, delay: HudDelay.error)
            : HUD.flash(.error, onView: self, delay: HudDelay.error)
    }
    
    func showSuccessHUD(title: String? = nil, subtitle: String? = nil, completion: ((Bool) -> Void)? = nil) {
        title != nil || subtitle != nil
            ? HUD.flash(.labeledSuccess(title: title, subtitle: subtitle), onView: self, delay: HudDelay.success, completion: completion)
            : HUD.flash(.success, onView: self, delay: HudDelay.success, completion: completion)
    }
    
    func showHUD(type: HUDContentType) {
        HUD.show(.success, onView: self)
    }
    
    func showFlashHUD(type: HUDContentType, delay: TimeInterval? = nil) {
        HUD.flash(type, onView: self, delay: delay ?? HudDelay.default)
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
