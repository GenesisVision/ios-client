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
    var currency: String { get }
    
    func textLabelDidChange(value: Double?)
    func onClearClicked(view: NumpadView)
    func onSeparatorClicked(view: NumpadView)
    func onNumberClicked(view: NumpadView, value: Int)
    func changedActive(value: Bool)
}

extension NumpadViewProtocol {
    func textLabelDidChange(value: Double?) {
        //update ui
    }
    
    func onClearClicked(view: NumpadView) {
        guard let text = textLabel.text, !text.isEmpty else { return }
        
        if text == "0." {
            textLabel.text?.removeAll()
        } else {
            textLabel.text?.removeLast(1)
        }
        
        if textLabel.text == "" {
            textLabel.text = 0.toString()
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
        guard let text = textLabel.text else { return }
        
        if text == "0" {
            textLabel.text = value == 0 ? "0." : value.toString()
        } else {
            textLabel.text?.append(value.toString())
        }
        
        if let text = textLabel.text, text.range(of: ".") != nil,
            let lastComponents = text.components(separatedBy: ".").last,
            lastComponents.count >= getDecimalCount(for: currency) {
            changedActive(value: false)
            return
        }
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
}

class NumpadView: UIView {
    
    weak var delegate: NumpadViewProtocol?
    
    @IBOutlet var numberButtons: [NumpadButton]!
    @IBOutlet var separatorButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    var isEnable = true {
        didSet {
            numberButtons.forEach { (button) in
                button.isEnabled = isEnable
                button.alpha = isEnable ? 1.0 : 0.3
            }
            
            separatorButton.isEnabled = isEnable
            separatorButton.alpha = isEnable ? 1.0 : 0.3
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
