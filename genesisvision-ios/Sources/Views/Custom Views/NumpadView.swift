//
//  NumpadView.swift
//  genesisvision-ios
//
//  Created by George on 25/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol NumpadViewProtocol: AnyObject {
    var textLabel: UILabel { get }
    var textPlaceholder: String? { get }
    var currency: CurrencyType? { get }
    var numbersLimit: Int? { get }
    var maxAmount: Double? { get }
    var minAmount: Double? { get }
    
    func clearAction()
    func textLabelDidChange(value: Double?)
    func onClearClicked(view: NumpadView)
    func onSeparatorClicked(view: NumpadView)
    func onNumberClicked(view: NumpadView, value: Int)
    func changedActive(value: Bool)
}

extension NumpadViewProtocol {
    var textPlaceholder: Double? {
        return nil
    }
    
    var currency: Double? {
        return nil
    }
    
    var numbersLimit: Double? {
        return nil
    }
    
    var maxAmount: Double? {
        return nil
    }
    
    var minAmount: Double? {
        return nil
    }
    
    func onClearClicked(view: NumpadView) {
        guard let text = textLabel.text, !text.isEmpty, text != textPlaceholder else { return }
        
        if text == "0." {
            textLabel.text?.removeAll()
        } else {
            textLabel.text?.removeLast(1)
        }
        
        if textLabel.text == "" {
            textLabel.text = textPlaceholder
        }
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
    
    func onSeparatorClicked(view: NumpadView) {
        guard let text = textLabel.text else { return }
        
        guard text.range(of: ".") == nil else {
            return
        }
        
        guard !text.isEmpty else {
            textLabel.text = "0."
            return
        }
        
        textLabel.text?.append(".")
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
    
    func onNumberClicked(view: NumpadView, value: Int) {
        let valueString: String = value.toString()
        guard let text = textLabel.text else { return }
        
        if currency == nil, let numbersLimit = numbersLimit, text.count < numbersLimit {
            return
        }
        
        let amountString = text + valueString
        
        guard let amount = Double(amountString) else { return }
        
        if let maxAmount = maxAmount, amount > maxAmount { return }
        if let minAmount = minAmount, amount < minAmount { return }
        
        if text == "0" {
            textLabel.text = value == 0 ? "0." : value.toString()
        } else {
            textLabel.text?.append(value.toString())
        }
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
        if let text = textLabel.text {
            updateNumPadState(text)
        }
    }
    
    func updateNumPadState(_ text: String) {
        if text.range(of: ".") != nil,
            let lastComponents = text.components(separatedBy: ".").last,
            lastComponents.count >= getDecimalCount(for: currency) {
            changedActive(value: false)
        } else if let numbersLimit = numbersLimit, text.count < numbersLimit {
            changedActive(value: false)
        } else {
            changedActive(value: true)
        }
    }
    
    func clearAction() {
        textLabel.text = textPlaceholder
        
        if let text = textLabel.text {
            textLabelDidChange(value: text.doubleValue)
            updateNumPadState(text)
        }
    }
}

enum NumpadViewType {
    case currency, number
}

class NumpadView: UIView {
    weak var delegate: NumpadViewProtocol?
    
    var type: NumpadViewType = .number
    
    @IBOutlet weak var numpadButtonHeightConstraint: NSLayoutConstraint! {
        didSet {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                numpadButtonHeightConstraint.constant = 40.0
            default:
                numpadButtonHeightConstraint.constant = 47.0
            }
        }
    }
    
    @IBOutlet var numberButtons: [NumpadButton]!
    @IBOutlet weak var separatorButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        switch type {
        case .currency:
            separatorButton.alpha = 1.0
        case .number:
            separatorButton.alpha = 0.0
        }
    }
    
    var isEnable = true {
        didSet {
            numberButtons.forEach { (button) in
                button.isEnabled = isEnable
                button.alpha = isEnable ? 1.0 : 0.3
            }
            
            switch type {
            case .currency:
                separatorButton.isEnabled = isEnable
                separatorButton.alpha = isEnable ? 1.0 : 0.3
            case .number:
                separatorButton.isEnabled = false
            }
        }
    }
    
    var isBlock = true {
        didSet {
            isEnable = isBlock
            
            clearButton.isEnabled = isBlock
            clearButton.alpha = isBlock ? 1.0 : 0.3
        }
    }
    
    var buttonBackgroundColor: UIColor = UIColor.BaseView.bg  {
        didSet {
            numberButtons.forEach { (button) in
                button.bgColor = buttonBackgroundColor
            }
        }
    }
    
    func clearAction() {
        delegate?.clearAction()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        delegate?.onClearClicked(view: self)
    }
    
    @IBAction func separatorButtonAction(_ sender: UIButton) {
        delegate?.onSeparatorClicked(view: self)
    }
    
    @IBAction func buttons(_ sender: NumpadButton) {
        delegate?.onNumberClicked(view: self, value: sender.tag)
    }
}
