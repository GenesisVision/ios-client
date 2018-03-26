//
//  NumpadView.swift
//  genesisvision-ios
//
//  Created by George on 25/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol NumpadViewProtocol: class {
    func onClearClicked(view: NumpadView)
    func onSeparatorClicked(view: NumpadView)
    func onNumberClicked(view: NumpadView, value: Int)
}

class NumpadView: UIView {
    
    weak var delegate: NumpadViewProtocol?
    
    @IBOutlet var numberButtons: [NumpadButton]!
    @IBOutlet var separatorButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
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
