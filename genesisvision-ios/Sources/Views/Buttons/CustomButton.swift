//
//  CustomButton.swift
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
            isUserInteractionEnabled = !isSelected
            setBackgroundImage(UIImage.imageWithColor(color: isSelected ? UIColor.DateRangeView.selectedBg : UIColor.DateRangeView.unselectedBg), for: .selected)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + 32,
                height: baseSize.height)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font = UIFont.getFont(.regular, size: 14)
        setTitleColor(UIColor.DateRangeView.unselectedTitle, for: .normal)
        setTitleColor(UIColor.DateRangeView.selectedTitle, for: .selected)
        backgroundColor = UIColor.DateRangeView.unselectedBg
        setBackgroundImage(nil, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners(with: 16)
    }
    
}

class LevelFilterButton: UIButton {
    
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
    
    override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + 32,
                          height: baseSize.height)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font = UIFont.getFont(.regular, size: 14)
        setTitleColor(UIColor.DateRangeView.unselectedTitle, for: .normal)
        setTitleColor(UIColor.DateRangeView.selectedTitle, for: .selected)
        backgroundColor = UIColor.DateRangeView.unselectedBg
        setBackgroundImage(nil, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners()
    }
    
}

struct ActionButtonOptions {
    var borderWidth: CGFloat? = nil
    var borderColor: UIColor? = nil
    
    var fontSize: CGFloat? = nil
    var bgColor: UIColor? = nil
    var textColor: UIColor? = nil
    
    var image: UIImage? = nil
    var rightPosition: Bool? = false
}

enum ActionButtonStyle {
    case normal
    case highClear
    case darkClear
    case filter(image: UIImage?)
    case custom(options: ActionButtonOptions)
}

class ActionButton: UIButton {

    var options: ActionButtonOptions?
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        setup(options ?? ActionButtonOptions(borderWidth: nil, borderColor: nil, fontSize: nil, bgColor: nil, textColor: nil, image: nil, rightPosition: nil))
    }
    
    func configure(with style: ActionButtonStyle) {
        switch style {
        case .darkClear:
            self.options = ActionButtonOptions(borderWidth: 1.0, borderColor: UIColor.Border.forButton, fontSize: nil, bgColor: UIColor.BaseView.bg, textColor: nil, image: nil, rightPosition: nil)
        case .highClear:
            self.options = ActionButtonOptions(borderWidth: 1.0, borderColor: UIColor.Cell.bg.withAlphaComponent(0.2), fontSize: nil, bgColor: UIColor.Common.white, textColor: UIColor.Cell.bg, image: nil, rightPosition: nil)
        case .filter(let image):
            self.options = ActionButtonOptions(borderWidth: nil, borderColor: nil, fontSize: nil, bgColor: UIColor.BottomView.Filter.bg, textColor: UIColor.BottomView.Filter.title, image: image, rightPosition: nil)
        case .custom(let options):
            self.options = options
        default:
            self.options = ActionButtonOptions(borderWidth: nil, borderColor: nil, fontSize: nil, bgColor: nil, textColor: nil, image: nil, rightPosition: nil)
        }
    }
    
    private func setup(_ options: ActionButtonOptions) {
        roundCorners()

        roundCorners(borderWidth: options.borderWidth ?? 0.0, borderColor: options.borderColor ?? UIColor.Common.white)
        setTitleColor(options.textColor ?? UIColor.Common.white, for: .normal)
        tintColor = options.textColor ?? UIColor.Common.white

        if let rightPosition = options.rightPosition {
            semanticContentAttribute = rightPosition ? .forceRightToLeft : .unspecified
        }
        
        if let image = options.image {
            setImage(image, for: .normal)
            
            let spacing: CGFloat = semanticContentAttribute == .forceRightToLeft ? -4.0 : 4.0
            
            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, spacing)
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, -spacing)
            contentEdgeInsets = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        }
        
        
        titleLabel?.font = UIFont.getFont(.semibold, size: options.fontSize ?? 14.0)
        backgroundColor = isUserInteractionEnabled ? options.bgColor ?? UIColor.primary : options.bgColor?.withAlphaComponent(0.3) ?? UIColor.primary.withAlphaComponent(0.3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commonInit()
    }
    
    func setEnabled(_ value: Bool) {
        isUserInteractionEnabled = value
        commonInit()
    }
}

class StatusButton: UIButton {

    var fontSize: CGFloat = 12.0
    var bgColor: UIColor = UIColor.Button.primary
    var textColor: UIColor = UIColor.Cell.title
    var contentEdge = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        if let status = titleLabel?.text {
            isUserInteractionEnabled = !(status == "Active" || status == "Ended")
            
            setImage(isUserInteractionEnabled ? #imageLiteral(resourceName: "img_arrow_down_icon") : nil, for: .normal)
            semanticContentAttribute = .forceRightToLeft
            
            let colors = UIColor.Status.colors(for: status)
            backgroundColor = colors.1
            setTitleColor(colors.0, for: .normal)
            tintColor = colors.0
        }
        
        titleLabel?.font = UIFont.getFont(.semibold, size: fontSize)
        
        var spacing: CGFloat = 0.0
        if image(for: .normal) != nil {
            spacing = semanticContentAttribute == .forceRightToLeft ? -4.0 : 4.0
        }
        
        imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, spacing)
        titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, -spacing)
        contentEdgeInsets = contentEdge
        
        roundCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commonInit()
    }
}

class LevelButton: UIButton {
    var fontSize: CGFloat = 14.0
    var borderSize: CGFloat = 3.0
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commonInit()
    }
    
    
    func commonInit() {
        titleLabel?.font = UIFont.getFont(.semibold, size: fontSize)

        roundCorners(borderWidth: borderSize, borderColor: UIColor.Cell.bg)
        
        setTitleColor(UIColor.Cell.title, for: .normal)
        if let level = Int(titleLabel?.text ?? "") {
            backgroundColor = UIColor.Level.color(for: level)
        }
    }
}
