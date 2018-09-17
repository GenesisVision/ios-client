//
//  ActionButton.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

@IBDesignable class RoundButton: UIButton {
    @IBInspectable var corner: CGFloat = 16 {
        didSet {
            refreshCorners(value: corner)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            refreshColor(color: backgroundImageColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: 16)
        refreshColor(color: UIColor.DateRangeView.selectedBg)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshColor(color: UIColor) {
        let image = createImage(color: color)
        setBackgroundImage(image, for: UIControlState.normal)
        clipsToBounds = true
    }
    
    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

class DateRangeButton: UIButton {
    
    override var buttonType: UIButtonType {
        return .system
    }
    
    override open var isHighlighted: Bool {
        didSet {
            setBackgroundImage(UIImage.imageWithColor(color: isHighlighted ? UIColor.DateRangeView.selectedBg : UIColor.DateRangeView.unselectedBg), for: .highlighted)
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            setBackgroundImage(UIImage.imageWithColor(color: isSelected ? UIColor.DateRangeView.selectedBg : UIColor.DateRangeView.unselectedBg), for: .selected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(UIColor.DateRangeView.unselectedTitle, for: .normal)
        setTitleColor(UIColor.DateRangeView.selectedTitle, for: .selected)
        setBackgroundImage(nil, for: .normal)
//        setBackgroundImage(nil, for: .selected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners(with: 16)
    }
}

class ActionButton: UIButton {
    
    var cornerSize: CGFloat = Constants.SystemSizes.cornerSize
    var borderSize: CGFloat = 0.0
    var customBorderColor: UIColor? = .white
    var borderAlpha: CGFloat = 1.0
    var fontSize: CGFloat = 14.0
    var bgColor: UIColor = UIColor.Button.primary
    var textColor: UIColor = UIColor.Font.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners(with: cornerSize, borderWidth: borderSize, borderColor: (customBorderColor?.withAlphaComponent(borderAlpha))!)
        
        titleLabel?.font = UIFont.getFont(.bold, size: fontSize)
        setTitleColor(textColor, for: .normal)
        
        backgroundColor = isUserInteractionEnabled ? bgColor : bgColor.withAlphaComponent(0.3)
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        if let color = color {
            self.textColor = color
        }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 6.0
        layer.masksToBounds = true
    }
    
    func setEnabled(_ value: Bool) {
        isUserInteractionEnabled = value
        backgroundColor = isUserInteractionEnabled ? bgColor : bgColor.withAlphaComponent(0.3)
    }
}
