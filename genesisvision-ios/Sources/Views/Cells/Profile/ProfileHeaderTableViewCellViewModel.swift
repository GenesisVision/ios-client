//
//  ProfileHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct ProfileHeaderTableViewCellViewModel {
    let profileEntity: ProfileEntity
    var editable: Bool
    weak var delegate: ProfileHeaderViewDelegate?
}

extension ProfileHeaderTableViewCellViewModel {
    func setup(on view: ProfileHeaderView) {
        if let avatar = profileEntity.avatar {
            let avatarURL = getFileURL(fileName: avatar)
            view.chooseProfilePhotoButton.photoImageView.kf.indicatorType = .activity
            view.chooseProfilePhotoButton.photoImageView.kf.setImage(with: avatarURL, placeholder: UIImage.placeholder)
        }
        
        view.delegate = delegate
    }
}
