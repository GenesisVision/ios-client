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
    let investmentProgram: InvestmentProgramDashboard
    weak var delegate: DashboardTableViewCellProtocol?
}

extension DashboardTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardTableViewCell) {
        cell.userNameLabel.text = ""
        
        if let manager = investmentProgram.manager {
            if let username = manager.username {
                cell.userNameLabel.text = username
            }
            
            cell.managerAvatarImageView.image = UIImage.placeholder
        
            if let avatar = manager.avatar {
                let avatarURL = getFileURL(fileName: avatar)
                cell.managerAvatarImageView.kf.indicatorType = .activity
                cell.managerAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage.placeholder)
            }
        }
        
        if let tokensCount = investmentProgram.investedTokens {
            cell.tokensCountLabel.text = String(describing: tokensCount) + " tokens"
        }
        
        if let endOfPeriod = investmentProgram.endOfPeriod {
            cell.periodLabel.text = endOfPeriod.defaultFormatString
        }
        
        if let profit = investmentProgram.profitTotal {
            cell.profitLabel.text = String(describing: profit) + "%"
        }
        
        if let investmentProgramId = investmentProgram.id?.uuidString {
            cell.investmentProgramId = investmentProgramId
        }
        
        if let level = investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = String(describing: level)
        }
        
        if let periodDuration = investmentProgram.periodDuration {
            cell.periodDurationLabel.text = String(describing: periodDuration)
        }
        
        cell.programLogoImageView.flagImageView.isHidden = true
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = investmentProgram.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.delegate = delegate
    }
}
