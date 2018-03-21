//
//  TraderDetailHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct TraderDetailHeaderTableViewCellViewModel {
    let participantViewModel: ParticipantViewModel
}

extension TraderDetailHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailHeaderTableViewCell) {
        cell.programLogoImageView.levelLabel.isHidden = true
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = participantViewModel.avatar {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
    }
}
