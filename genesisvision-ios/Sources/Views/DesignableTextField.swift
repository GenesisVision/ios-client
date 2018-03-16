//
//  DesignableTextField.swift
//  genesisvision-ios
//
//  Created by George on 16/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var bottomlineColor: UIColor = UIColor.TextField.line
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
            
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: newValue ?? UIColor.TextField.placeholder])
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
    func setBottomLine(borderColor: UIColor) {
        borderStyle = UITextBorderStyle.none
        backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 3.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        addSubview(borderLine)
    }
    
    func underlined(borderColor: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    // MARK: - Lifecycle
    func viewDidLayoutSubviews() {
        setBottomLine(borderColor: bottomlineColor)
//        underlined(borderColor: bottomlineColor)
    }
}
