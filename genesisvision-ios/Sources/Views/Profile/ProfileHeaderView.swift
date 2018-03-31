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
            chooseProfilePhotoButton.change(state: profileState)
        }
    }
    
    // MARK: - Views
    @IBOutlet var backgroundImageView: UIImageView!
    
    // MARK: - Buttons
    @IBOutlet var chooseProfilePhotoButton: ChooseProfilePhotoButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
    }
    
    // MARK: - Private methdos
    
    // MARK: - Public Methods
    func setup(with avatarURL: URL? = nil) {
        update(avatar: avatarURL)
    }
    
    
    func update(avatar url: URL?) {
        chooseProfilePhotoButton.photoImageView.image = UIImage.placeholder
        
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
    
    
    // MARK: - Actions
    @IBAction func chooseButtonAction(_ sender: Any) {
        delegate?.chooseProfilePhotoDidPressOnPhoto(self)
    }
    
}

