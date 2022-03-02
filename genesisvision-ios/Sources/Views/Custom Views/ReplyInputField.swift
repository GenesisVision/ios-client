//
//  ReplyInputField.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol ReplyInputFieldDelegate: AnyObject {
    func attachmentButtonPressed()
    func sendButtonPressed()
    func removeImage(imageUrl: String)
}

class ReplyInputField: UIView {
    
    enum SocialPostViewModelMode {
        case add
        case edit
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    let replierView: ReplierView = {
        let view = ReplierView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var mode : SocialPostViewModelMode = .add
    
    let imageGallery: ImagesGalleryView = {
        let imageGallery = ImagesGalleryView()
        imageGallery.translatesAutoresizingMaskIntoConstraints = false
        return imageGallery
    }()
    
    private let fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    let attachmentButton: UIButton = {
        let attachmentButton = UIButton()
        let image = UIImage(named: "image_placeholder")?.withRenderingMode(.alwaysTemplate)
        attachmentButton.setImage(image, for: .normal)
        attachmentButton.tintColor = UIColor.Common.white
        return attachmentButton
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "sendButtonImage")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.Common.white
        return button
    }()
    
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Comment"
        textfield.textAlignment = .left
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private weak var delegate: ReplyInputFieldDelegate?
    
    func configure(viewModels: [ImagesGalleryCollectionViewCellViewModel], delegate: ReplyInputFieldDelegate?) {
        self.delegate = delegate
        imageGallery.viewModels = viewModels
        imageGallery.isHidden = viewModels.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        attachmentButton.addTarget(self, action: #selector(attachmentButtonPressed), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mainStackView)
        mainStackView.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        mainStackView.addArrangedSubview(replierView)
        mainStackView.addArrangedSubview(imageGallery)
        mainStackView.addArrangedSubview(fieldStackView)
        
        replierView.anchorSize(size: CGSize(width: 0, height: 20))
        imageGallery.anchorSize(size: CGSize(width: 0, height: 100))
        fieldStackView.anchorSize(size: CGSize(width: 0, height: 30))
        
        fieldStackView.addArrangedSubview(attachmentButton)
        fieldStackView.addArrangedSubview(textField)
        fieldStackView.addArrangedSubview(sendButton)
        
        attachmentButton.anchorSize(size: CGSize(width: 30, height: 30))
        textField.anchorSize(size: CGSize(width: 0, height: 30))
        sendButton.anchorSize(size: CGSize(width: 30, height: 30))
    }
    
    @objc private func textFieldDidChange() {
        guard let text = textField.text, !text.isEmpty else {
            sendButton.tintColor = UIColor.white
            return }
        sendButton.tintColor = UIColor.primary
    }
    
    @objc private func attachmentButtonPressed() {
        delegate?.attachmentButtonPressed()
    }
    
    @objc private func sendButtonPressed() {
        delegate?.sendButtonPressed()
    }
    
}

extension ReplyInputField: ImagesGalleryCollectionViewCellDelegate {
    func removeImage(imageUrl: String) {
        delegate?.removeImage(imageUrl: imageUrl)
    }
}
