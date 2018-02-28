//
//  ProfileImageView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView

class ProfileImageView: UIView {
    @IBOutlet var profilePhotoImageView: UIImageView! {
        didSet {
            profilePhotoImageView.roundCorners()
        }
    }
    
    @IBOutlet var flagImageView: RoundedImageView! {
        didSet {
            flagImageView.image = UIImage.placeholder
            guard let _ = flagImageView.image else { return }
            flagImageView.addBorder(withBorderWidth: 2.0)
        }
    }
    
    @IBOutlet var levelLabel: UILabel! {
        didSet {
            levelLabel.backgroundColor = .clear
            levelLabel.layer.backgroundColor = UIColor.darkPrimary.cgColor
            levelLabel.roundWithBorder(2.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePhotoImageView.roundCorners()
        levelLabel.roundWithBorder(2.0)
    }
}
