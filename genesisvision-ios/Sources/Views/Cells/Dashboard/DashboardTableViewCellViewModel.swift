//
//  DashboardTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct DashboardTableViewCellViewModel {
    let investmentProgram: InvestmentProgram
    weak var delegate: DashboardTableViewCellProtocol?
}

extension DashboardTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardTableViewCell) {
        var username = ""
        let tokensCount = 0
        
        if let account = investmentProgram.account {
            username = account.login ?? ""
        }
        
        guard let investment = investmentProgram.investment else {
            return
        }
        
        cell.userNameLabel.text = username
        cell.tokensCountLabel.text = String(describing: tokensCount)
        
        if let rating = investment.rating {
            cell.programLogoImageView.levelLabel.text = String(describing: Int(rating))
        }
        
        cell.programLogoImageView.flagImageView.isHidden = true
        
        if let logo = investment.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        if let manager = investmentProgram.manager, let avatar = manager.avatar {
            let avatarURL = getFileURL(fileName: avatar)
            cell.managerAvatarImageView.kf.indicatorType = .activity
            cell.managerAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage.placeholder)
        }
        
        cell.delegate = delegate
    }
}
