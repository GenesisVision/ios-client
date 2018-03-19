//
//  DesignableTextField.swift
//  genesisvision-ios
//
//  Created by George on 16/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField, UITextFieldDelegate {
    
    var padding: UIEdgeInsets {
        get {
            var imageWidth: CGFloat = 0
            if let leftImage = leftImage {
                imageWidth = leftImage.size.width
            }

            return UIEdgeInsets(top: 0, left: leftPadding + imageWidth + rightPadding, bottom: 0, right: 0)
        }
    }
    
    @IBInspectable var leftImage: UIImage?
    
    @IBInspectable var clearImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 3
    @IBInspectable var rightPadding: CGFloat = 18
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var bottomlineHeight: Double = 1.0
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
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        if let image = clearImage {
            rightViewMode = UITextFieldViewMode.whileEditing
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            rightView = imageView
        }
        
        
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
    func setBottomLine(borderColor: UIColor) {
        borderStyle = UITextBorderStyle.none
        backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = bottomlineHeight
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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBottomLine(borderColor: bottomlineColor)
        leftImage = isSecureTextEntry ? #imageLiteral(resourceName: "img_textfield_password_colored_icon") : #imageLiteral(resourceName: "img_textfield_email_colored_icon")
        
        font = UIFont(name: "NeuzeitGro-Reg", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        
        clearImage = #imageLiteral(resourceName: "img_textfield_clear")
        
        if let text = text {
            leftImage = !text.isEmpty ? isSecureTextEntry ? #imageLiteral(resourceName: "img_textfield_password_icon") : #imageLiteral(resourceName: "img_textfield_email_icon") : isSecureTextEntry ? #imageLiteral(resourceName: "img_textfield_password_colored_icon") : #imageLiteral(resourceName: "img_textfield_email_colored_icon")
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
