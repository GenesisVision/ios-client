//
//  DetailManagerTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailManagerTableViewCellViewModel {
    let manager: ProfilePublic
}

extension DetailManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailManagerTableViewCell) {
        if let registrationDate = manager.registrationDate {
            cell.dateLabel.text = registrationDate.onlyDateFormatString
        }
        
        if let username = manager.username {
            cell.managerNameLabel.text = username
        }
        
        cell.managerImageView.image = UIImage.profilePlaceholder
        
        if let fileName = manager.avatar, let fileUrl = getFileURL(fileName: fileName) {
            cell.managerImageView.kf.indicatorType = .activity
            cell.managerImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
    }
}
