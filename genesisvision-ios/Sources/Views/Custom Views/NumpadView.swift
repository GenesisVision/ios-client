//
//  NumpadView.swift
//  genesisvision-ios
//
//  Created by George on 25/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol NumpadViewProtocol: class {
    var textLabel: UILabel { get }
    var textPlaceholder: String? { get }
    var currency: String? { get }
    var numbersLimit: Int { get }
    var amountLimit: Double? { get }
    
    func textLabelDidChange(value: Double?)
    func onClearClicked(view: NumpadView)
    func onSeparatorClicked(view: NumpadView)
    func onNumberClicked(view: NumpadView, value: Int)
    func changedActive(value: Bool)
}

extension NumpadViewProtocol {
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
        guard let text = textLabel.text, currency != nil || text.count < numbersLimit else { return }
        let amountString = text + valueString
        
        if let amountLimit = amountLimit, let amount = Double(amountString), amount > amountLimit {
            return
        }
        
        if text == "0" {
            textLabel.text = value == 0 ? "0." : value.toString()
        } else {
            textLabel.text?.append(value.toString())
        }
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
    
    func updateNumPadState(text: String) {
        if text.range(of: ".") != nil,
            let lastComponents = text.components(separatedBy: ".").last,
            lastComponents.count >= getDecimalCount(for: currency) {
            changedActive(value: false)
        } else if text.count < numbersLimit {
            changedActive(value: false)
        } else {
            changedActive(value: true)
        }
    }
}

enum NumpadViewType {
    case currency, number
}

class NumpadView: UIView {
    weak var delegate: NumpadViewProtocol?
    
    var type: NumpadViewType = .number
    
    @IBOutlet var numberButtons: [NumpadButton]!
    @IBOutlet var separatorButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
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
    
    var buttonBackgroundColor: UIColor = UIColor.BaseView.bg  {
        didSet {
            numberButtons.forEach { (button) in
                button.bgColor = buttonBackgroundColor
            }
        }
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
