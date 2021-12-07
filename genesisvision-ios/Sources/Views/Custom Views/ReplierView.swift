//
//  ReplierView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol ReplierViewDelegate: AnyObject {
    func removeButtonPressed()
}

class ReplierView: UIView {
    
    private let label: SubtitleLabel = {
        let label = SubtitleLabel()
        label.font = UIFont.getFont(.regular, size: 13.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "img_close_icon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private weak var delegate: ReplierViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(replingPost: Post?, delegate: ReplierViewDelegate?) {
        self.delegate = delegate
        guard let authorName = replingPost?.author?.username else {
            isHidden = true
            return }
        isHidden = false
        
        let text = "Reply to" + " " + authorName
        
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: authorName)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primary, range: range)
        label.attributedText = underlineAttriString
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
        label.sizeToFit()
    }
    
    private func setup() {
        backgroundColor = UIColor.Common.darkCell
        removeButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(label)
        addSubview(removeButton)
        
        label.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: nil,
                     padding: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5),
                     size: CGSize(width: 0, height: 15))
        
        removeButton.anchorSize(size: CGSize(width: 11, height: 11))
        removeButton.anchorCenter(centerY: label.centerYAnchor, centerX: nil)
        removeButton.anchor(top: nil,
                            leading: label.trailingAnchor,
                            bottom: nil,
                            trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    @objc private func removeButtonPressed() {
        delegate?.removeButtonPressed()
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        delegate?.removeButtonPressed()
    }
}
