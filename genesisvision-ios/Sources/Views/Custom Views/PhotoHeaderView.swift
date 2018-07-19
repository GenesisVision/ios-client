//
//  PhotoHeaderView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol PhotoHeaderViewDelegate: class {
    func didPressOnPhotoButton(_ view: PhotoHeaderView)
}

enum EditableState {
    case show
    case edit
}

class PhotoHeaderView: UIView {
    
    // MARK: - Variables
    weak var delegate: PhotoHeaderViewDelegate?
    
    var editableState: EditableState = .show {
        didSet {
            choosePhotoView.state = editableState
        }
    }
        
    // MARK: - Views
    @IBOutlet var backgroundImageView: UIImageView!
    
    // MARK: - Buttons
    @IBOutlet var choosePhotoView: СhoosePhotoView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Private methdos

    // MARK: - Public Methods
    func setup(with avatarURL: URL? = nil) {
        updateAvatar(url: avatarURL)
    }
    
    func updateAvatar(url: URL? = nil, image: UIImage? = nil) {
        choosePhotoView.photoImageView.image = UIImage.placeholder
        
        if let image = image {
            choosePhotoView.photoImageView.image = image
        } else if let url = url {
            choosePhotoView.photoImageView.kf.indicatorType = .activity
            choosePhotoView.photoImageView.kf.setImage(with: url, placeholder: UIImage.placeholder)
        }
    }
    
    func update(avatar image: UIImage?) {
        if let image = image {
            choosePhotoView.photoImageView.image = image
        }
    }
    
    // MARK: - Actions
    @IBAction func chooseButtonAction(_ sender: Any) {
        delegate?.didPressOnPhotoButton(self)
    }
}
