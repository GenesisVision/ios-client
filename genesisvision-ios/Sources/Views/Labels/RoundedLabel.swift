//
//  RoundedLabel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

class RoundedLabel: UILabel {
    
    var edgeInsets: UIEdgeInsets!

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
        self.backgroundColor = .clear
        self.setProperties()
    }
    
    func setProperties(font: UIFont? = UIFont.getFont(.semibold, size: 12),
                       textColor: UIColor? = UIColor.Cell.title,
                       backgroundColor: UIColor? = UIColor.Cell.title.withAlphaComponent(0.3),
                       edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.edgeInsets = edgeInsets
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += edgeInsets.top + edgeInsets.bottom
        intrinsicSuperViewContentSize.width += edgeInsets.left + edgeInsets.right
        return intrinsicSuperViewContentSize
    }
}

class CurrencyLabel: RoundedLabel {
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func commonInit() {
        super.commonInit()

        if let text = text {
            let currencyType = CurrencyType(rawValue: text)
            let currencyColor = currencyType?.currencyColor
            backgroundColor = currencyColor?.withAlphaComponent(0.1)
            textColor = currencyColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.commonInit()
    }
}

class WhiteCurrencyLabel: RoundedLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        setProperties(textColor: UIColor.Font.primary, backgroundColor: UIColor.Font.white)
    }
}
