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
    func changePasswordButtonDidPress(_ sender: UIButton)
    func enableTwoFactorButtonDidPress(_ value: Bool)
}

class ProfileHeaderView: UIView {
    
    // MARK: - Variables
    weak var delegate: ProfileHeaderViewDelegate?
    
    var profileState: ProfileState = .show {
        didSet {
            chooseProfilePhotoButton.change(state: profileState)
        }
    }
    
    var twoFactorEnable: Bool = false {
        didSet {
            let titleText = twoFactorEnable ? String.Buttons.disableTwoFactorAuthentication : String.Buttons.enableTwoFactorAuthentication
            enableTwoFactorButton.setTitle(titleText.uppercased(), for: .normal)
        }
    }
        
    // MARK: - Views
    @IBOutlet var backgroundImageView: UIImageView!
    
    // MARK: - Buttons
    @IBOutlet var chooseProfilePhotoButton: ChooseProfilePhotoButton!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var enableTwoFactorButton: UIButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        NotificationCenter.default.addObserver(self, selector: #selector(twoFactorChangeNotification(notification:)), name: .twoFactorChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorChange, object: nil)
    }
    
    // MARK: - Private methdos
    @objc private func twoFactorChangeNotification(notification: Notification) {
        if let enable = notification.userInfo?["enable"] as? Bool {
            twoFactorEnable = enable
        }
    }
    
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
    
    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        delegate?.changePasswordButtonDidPress(sender)
    }
    
    @IBAction func enableTwoFactorButtonAction(_ sender: UIButton) {
        delegate?.enableTwoFactorButtonDidPress(!twoFactorEnable)
    }
}
