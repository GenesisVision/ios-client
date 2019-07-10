//
//  DesignableTextField.swift
//  genesisvision-ios
//
//  Created by George on 16/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DesignableUITextFieldDelegate: class {
    func textFieldDidClear()
}

class DesignableUITextField: UITextField, UITextFieldDelegate {
    
    weak var designableTextFieldDelegate: DesignableUITextFieldDelegate?
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var leftImage: UIImage?
    
    var clearImage: UIImage = #imageLiteral(resourceName: "img_textfield_clear")
    
    var leftPadding: CGFloat = 3
    var rightPadding: CGFloat = 16.0
    let imageWidth: CGFloat = 16.0
    
    var color: UIColor = UIColor.primary
    
    var bottomlineHeight: Double = 1.0
    var bottomlineColor: UIColor = UIColor.TextField.line
    
    var borderLine = UIView()
    
    var placeholderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? UIColor.TextField.placeholder])
        }
    }
    
    func setBottomLine(borderColor: UIColor? = UIColor.TextField.line) {
        layoutIfNeeded()
        
        borderStyle = UITextField.BorderStyle.none
        backgroundColor = UIColor.clear
        
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - bottomlineHeight, width: Double(self.frame.width), height: bottomlineHeight)
        
        borderLine.backgroundColor = borderColor
        
        addSubview(borderLine)
    }
    
    func setClearButtonWhileEditing() {
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        clearButton.setImage(clearImage, for: .normal)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(clearClicked(sender:)), for: .touchUpInside)
        rightView = clearButton
        clearButtonMode = .never
        rightViewMode = .whileEditing
    }
    
    func addPadding() {
        padding = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }
    
    func setLeftImageView() {
        if let text = text {
            leftImage = !text.isEmpty
                ? textContentType == UITextContentType.emailAddress
                    ? #imageLiteral(resourceName: "img_textfield_email_icon")
                    : textContentType == UITextContentType.nickname
                        ? #imageLiteral(resourceName: "img_tabbar_profile_unselected")
                        : isSecureTextEntry
                            ? #imageLiteral(resourceName: "img_textfield_password_icon")
                            : nil
                : textContentType == UITextContentType.emailAddress
                    ? #imageLiteral(resourceName: "img_textfield_email_colored_icon")
                    : textContentType == UITextContentType.nickname
                        ? #imageLiteral(resourceName: "img_tabbar_profile_unselected")
                        : isSecureTextEntry
                            ? #imageLiteral(resourceName: "img_textfield_password_colored_icon")
                            : nil
        }
        
        guard let image = leftImage else {
            return
        }
        
        leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16.0, height: 16.0))
        imageView.image = image
        imageView.contentMode = .center
        imageView.tintColor = color
        leftView = imageView
        
        padding = UIEdgeInsets(top: 0, left: leftPadding + imageWidth + rightPadding, bottom: 0, right: 0)
    }
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textColor = UIColor.TextField.title
        self.placeholderColor = UIColor.Cell.subtitle
        self.font = UIFont.getFont(.regular, size: 16)
        
        keyboardAppearance = .dark
        
        placeholder = ""
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.placeholderColor = UIColor.Cell.subtitle
        
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - bottomlineHeight, width: Double(self.frame.width), height: bottomlineHeight)
    }
    
    // MARK: - Private methods
    @objc private func clearClicked(sender: UIButton) {
        text = ""
        designableTextFieldDelegate?.textFieldDidClear()
    }
}
