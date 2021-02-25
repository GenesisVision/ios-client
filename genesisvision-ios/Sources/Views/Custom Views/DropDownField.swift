//
//  DropDownField.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol DropDownFieldDelegate: class {
    func droDownFieldPressed(uuidString: String, titleString: String)
}

class DropDownField: UIView {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let topLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.getFont(.medium, size: 14.0)
        return label
    }()
    
    private let titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.getFont(.medium, size: 16.0)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let arroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: "img_arrow_down_icon")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var uuidString: String = ""
    private weak var delegate: DropDownFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(mainView)
        mainView.fillSuperview()
        
        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.Common.darkTextSecondary
        addSubview(borderLine)
        
        borderLine.anchor(top: nil, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
        mainView.addSubview(topLabel)
        mainView.addSubview(titleLabel)
        mainView.addSubview(button)
        mainView.addSubview(arroImageView)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        topLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 30))
        
        titleLabel.anchor(top: topLabel.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        
        button.fillSuperview()
        arroImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: button.trailingAnchor, size: CGSize(width: 15, height: 10))
        arroImageView.anchorCenter(centerY: titleLabel.centerYAnchor, centerX: nil)
    }
    
    func configure(id: String, fieldDelegate: DropDownFieldDelegate, topLabelText: String, titleLabelText: String) {
        uuidString = id
        delegate = fieldDelegate
        topLabel.text = topLabelText
        titleLabel.text = titleLabelText
    }
    
    @objc private func buttonPressed() {
        guard !uuidString.isEmpty else { return }
        delegate?.droDownFieldPressed(uuidString: uuidString, titleString: topLabel.text ?? "")
    }
    
}
