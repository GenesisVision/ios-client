//
//  ProfileHeaderView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func chooseProfilePhotoDidPressOnPhoto(_ view: ProfileHeaderView)
}

class ProfileHeaderView: UIView {
    
    // MARK: - Variables
    weak var delegate: ProfileHeaderViewDelegate?
    
    var profileState: ProfileState = .show {
        didSet {
            hideLabel(value: profileState == .edit)
            chooseProfilePhotoButton.change(state: profileState)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var chooseProfilePhotoButton: ChooseProfilePhotoButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
    }
    
    // MARK: - Private methdos
    private func hideLabel(value: Bool) {
        nameLabelHeightConstraint.constant = value ? 0.0 : 30.0
        nameLabelTopConstraint.constant = value ? 0.0 : 16.0
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Public Methods
    func setup(with title: String? = nil, avatarURL: URL? = nil) {
        update(title: title)
        update(avatar: avatarURL)
    }
    
    
    func update(avatar url: URL?) {
        if let url = url {
            chooseProfilePhotoButton.photoImageView.kf.indicatorType = .activity
            chooseProfilePhotoButton.photoImageView.kf.setImage(with: url, placeholder: UIImage.placeholder)
        }
    }
    
    func update(avatar image: UIImage?) {
        if let image = image {
            chooseProfilePhotoButton.photoImageView.image = image
        }
    }
    
    func update(title text: String?) {
        if let text = text {
            hideLabel(value: false)
            nameLabel.text = text
        }
    }
    
    
    // MARK: - Actions
    @IBAction func chooseButtonAction(_ sender: Any) {
        delegate?.chooseProfilePhotoDidPressOnPhoto(self)
    }
    
}

