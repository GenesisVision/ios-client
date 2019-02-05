//
//  ProfileImageView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView

class ProfileImageView: UIView {
    @IBOutlet weak var profilePhotoImageView: UIImageView! {
        didSet {
            profilePhotoImageView.contentMode = .scaleAspectFill
            profilePhotoImageView.clipsToBounds = true
            profilePhotoImageView.image = UIImage.profilePlaceholder
            profilePhotoImageView.roundCorners(with: 6.0)
        }
    }
    
    @IBOutlet weak var readMoreImageView: UIImageView! {
        didSet {
            readMoreImageView.image = #imageLiteral(resourceName: "img_program_read_more")
            readMoreImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var levelButton: LevelButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
