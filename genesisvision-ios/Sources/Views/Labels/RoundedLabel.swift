//
//  RoundedLabel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

class RoundedLabel: UILabel {
    
    var topInset: CGFloat = 4.0
    var bottomInset: CGFloat = 4.0
    var leftInset: CGFloat = 8
    var rightInset: CGFloat = 8
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        font = UIFont.getFont(.bold, size: 10)

        layer.backgroundColor = UIColor.Font.primary.cgColor
        textColor = UIColor.Font.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class CurrencyLabel: RoundedLabel {

    var currencyType: CurrencyType = .gvt {
        didSet {
            var currencyColor = UIColor.Currency.gvt.cgColor
            
            switch currencyType {
            case .gvt:
                currencyColor = UIColor.Currency.gvt.cgColor
            case .btc:
                currencyColor = UIColor.Currency.btc.cgColor
            case .eth:
                currencyColor = UIColor.Currency.eth.cgColor
            case .eur:
                currencyColor = UIColor.Currency.eur.cgColor
            case .usd:
                currencyColor = UIColor.Currency.usd.cgColor
            default:
                break
            }
            
            layer.backgroundColor = currencyColor
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var currencyColor = UIColor.Currency.gvt.cgColor
        
        switch currencyType {
        case .gvt:
            currencyColor = UIColor.Currency.gvt.cgColor
        case .btc:
            currencyColor = UIColor.Currency.btc.cgColor
        case .eth:
            currencyColor = UIColor.Currency.eth.cgColor
        case .eur:
            currencyColor = UIColor.Currency.eur.cgColor
        case .usd:
            currencyColor = UIColor.Currency.usd.cgColor
        default:
            break
        }
        
        layer.backgroundColor = currencyColor
        textColor = UIColor.Font.white
    }
}

class WhiteCurrencyLabel: RoundedLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        layer.backgroundColor = UIColor.Font.white.cgColor
        textColor = UIColor.Font.primary
    }
}

class TournamentPlaceLabel: RoundedLabel {
    override var text: String? {
        didSet {
            let attachment = NSTextAttachment()
            attachment.image = #imageLiteral(resourceName: "img_trophy_small_icon")
            attachment.bounds = CGRect(x: 0.0, y: -4.0, width: 15.0, height: 15.0)
            let attachmentStr = NSAttributedString(attachment: attachment)

            let mutableAttributedString = NSMutableAttributedString()
            mutableAttributedString.append(attachmentStr)
            
            let textString = NSAttributedString(string: text ?? "", attributes: [.font: UIFont.getFont(.bold, size: 11)])
            mutableAttributedString.append(textString)
            
            self.textAlignment = .center
            self.attributedText = mutableAttributedString
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.backgroundColor = UIColor.Tournament.bg.cgColor
        textColor = UIColor.Font.white
    }
}
