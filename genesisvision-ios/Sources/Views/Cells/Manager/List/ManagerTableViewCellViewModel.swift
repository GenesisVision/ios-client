//
//  ManagerTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct ManagerTableViewCellViewModel {
    let profile: PublicProfile
    let selectable: Bool
    weak var delegate: DetailManagerTableViewCellDelegate?
}

extension ManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailManagerTableViewCell) {
        cell.delegate = delegate
        if let registrationDate = profile.regDate {
            cell.dateLabel.text = "since " + registrationDate.onlyDateFormatString
        }
        
        if let username = profile.username {
            cell.managerNameLabel.text = username
        }
        
        cell.managerImageView.image = UIImage.profilePlaceholder
        
        if let fileName = profile.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.managerImageView.kf.indicatorType = .activity
            cell.managerImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
        
        cell.arrowImageView.isHidden = !selectable
        cell.selectionStyle = selectable ? .default : .none
        
        if let followed = profile.personalDetails?.isFollow, followed {
            cell.followButton.setTitle("Unfollow", for: .normal)
            cell.followButton.configure(with: .darkClear)
        }

        cell.followed = profile.personalDetails?.isFollow
        cell.userId = profile._id
    }
}
