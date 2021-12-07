//
//  DetailManagerTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailManagerTableViewCellViewModel {
    let profilePublic: PublicProfile
    weak var delegate: DetailManagerTableViewCellDelegate?
}

extension DetailManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailManagerTableViewCell) {
        cell.delegate = delegate
        
        if let registrationDate = profilePublic.regDate {
            cell.dateLabel.text = "since " + registrationDate.onlyDateFormatString
        }
        
        if let username = profilePublic.username {
            cell.managerNameLabel.text = username
        }
        
        cell.managerImageView.image = UIImage.profilePlaceholder
        
        if let fileName = profilePublic.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.managerImageView.kf.indicatorType = .activity
            cell.managerImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }

        if let followed = profilePublic.personalDetails?.isFollow, followed {
            cell.followButton.setTitle("Unfollow", for: .normal)
            cell.followButton.configure(with: .darkClear)
        }

        cell.followed = profilePublic.personalDetails?.isFollow
        cell.userId = profilePublic._id
    }
}


struct DetailTradingAccountTableViewCellViewModel {
    let dashboardTradingAsset: DashboardTradingAsset
}

extension DetailTradingAccountTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailTradingAccountTableViewCell) {
        if let type = dashboardTradingAsset.accountInfo?.type {
            cell.subtitleLabel.text = type.rawValue
        }
        
        if let username = dashboardTradingAsset.broker?.name {
            cell.titleLabel.text = username
        }
        
        cell.logoImageView.image = UIImage.profilePlaceholder
        
        if let fileName = dashboardTradingAsset.broker?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.logoImageView.kf.indicatorType = .activity
            cell.logoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
    }
}
