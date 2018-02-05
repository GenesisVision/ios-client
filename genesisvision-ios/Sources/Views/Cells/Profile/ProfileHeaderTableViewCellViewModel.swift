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
    weak var delegate: ProfileHeaderTableViewCellDelegate?
}

extension ProfileHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProfileHeaderTableViewCell) {
        if let avatar = profileEntity.avatar {
            let avatarURL = URL(string: avatar)
            cell.chooseProfilePhotoButton.photoImageView.kf.indicatorType = .activity
            cell.chooseProfilePhotoButton.photoImageView.kf.setImage(with: avatarURL, placeholder: UIImage.placeholder)
        }
        
        cell.hideLabel(value: editable)
        cell.nameLabel.text = editable ? nil : profileEntity.fullName
        
        cell.delegate = delegate
    }
}
