//
//  CustomRadioButton.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

enum CustomRadioButtonState {
    case selected
    case unselected
}

protocol CustomRadioButtonDelegate: AnyObject {
    func pressed(state: CustomRadioButtonState, tag: String)
}

class CustomRadioButton: UIView {
    
    private let leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cirleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private var firstColor: UIColor = UIColor.Common.primary
    private var secondColor: UIColor = UIColor.Common.darkButtonBackground
    private var customTag: String = ""
    public private(set) var state: CustomRadioButtonState = .unselected
    
    private weak var delegate: CustomRadioButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        
        let gestRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTouched))
        gestRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(gestRecognizer)
        
        overlayLayers()
    }
    
    private func overlayLayers() {
        addSubview(leftView)
        addSubview(rightView)
        
        
        leftView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        leftView.widthAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 1.0).isActive = true
        
        leftView.addSubview(cirleView)
        
        
        rightView.anchor(top: topAnchor, leading: leftView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
        rightView.addSubview(label)
        label.fillSuperview()
    }
    
    @objc private func buttonTouched() {
        delegate?.pressed(state: state, tag: customTag)
    }
    
    
    func configure(delegate: CustomRadioButtonDelegate?, tag: String? = nil, labelText: String?, firstColor: UIColor?, secondColor: UIColor?, animatable: Bool = true) {
        self.delegate = delegate
        
        if let labelText = labelText, !labelText.isEmpty {
            label.text = labelText
        }
        
        if let tag = tag, !tag.isEmpty {
            customTag = tag
        }
    }
}
