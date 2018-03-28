//
//  ChooseProfilePhotoButton.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ChooseProfilePhotoButton: UIView {
    // MARK: - Outlets
    @IBOutlet var shadowView: UIView!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var editImageView: UIImageView!
    
    @IBOutlet var choosePhotoButton: UIButton! {
        didSet {
            choosePhotoButton.backgroundColor = .clear
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editImageView.isHidden = true
        editImageView.tintColor = UIColor.Font.white
        editImageView.image = #imageLiteral(resourceName: "img_profile_image_edit")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public methdods
    func change(state: ProfileState) {
        choosePhotoButton.isHidden = state == .show
        shadowView.isHidden = state == .show
        editImageView.isHidden = state == .show
    }
}

