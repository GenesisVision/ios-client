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
}

extension ManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailManagerTableViewCell) {
        if let registrationDate = profile.regDate {
            cell.dateLabel.text = "since " + registrationDate.onlyDateFormatString
        }
        
        if let username = profile.username {
            cell.managerNameLabel.text = username
        }
        
        cell.managerImageView.image = UIImage.profilePlaceholder
        
        if let fileName = profile.avatar, let fileUrl = getFileURL(fileName: fileName) {
            cell.managerImageView.kf.indicatorType = .activity
            cell.managerImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
    }
}
