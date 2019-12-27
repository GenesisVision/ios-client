//
//  DetailManagerTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailManagerTableViewCellViewModel {
    let profilePublic: ProfilePublic
}

extension DetailManagerTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailManagerTableViewCell) {
        if let registrationDate = profilePublic.registrationDate {
            cell.dateLabel.text = "since " + registrationDate.onlyDateFormatString
        }
        
        if let username = profilePublic.username {
            cell.managerNameLabel.text = username
        }
        
        cell.managerImageView.image = UIImage.profilePlaceholder
        
        if let fileName = profilePublic.avatar, let fileUrl = getFileURL(fileName: fileName) {
            cell.managerImageView.kf.indicatorType = .activity
            cell.managerImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
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
        
        if let fileName = dashboardTradingAsset.broker?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.logoImageView.kf.indicatorType = .activity
            cell.logoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
    }
}
