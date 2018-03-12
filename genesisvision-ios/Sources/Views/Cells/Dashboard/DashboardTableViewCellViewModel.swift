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
        if let title = investmentProgram.title {
            cell.titleLabel.text = title
        }
        
        if let manager = investmentProgram.manager {
            cell.managerAvatarImageView.image = UIImage.placeholder
        
            if let avatar = manager.avatar {
                let avatarURL = getFileURL(fileName: avatar)
                cell.managerAvatarImageView.kf.indicatorType = .activity
                cell.managerAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage.placeholder)
            }
        }
        
        if let tokensCount = investmentProgram.investedTokens {
            cell.tokensCountLabel.text = tokensCount.toString() + " tokens"
            cell.investedTokens = tokensCount
        }
        
        if let endOfPeriod = investmentProgram.endOfPeriod {
            let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
            cell.periodLeftValueLabel.text = periodLeft.0
            cell.periodLeftTitleLabel.text = periodLeft.1
            cell.periodLabel.text = endOfPeriod.defaultFormatString
        }
        
        if let profit = investmentProgram.profitTotal {
            cell.profitLabel.text = profit.toString() + "%"
            cell.profitLabel.textColor = profit == 0 ? UIColor.Font.medium : profit > 0 ? UIColor.Font.green : UIColor.Font.red
        }
        
        if let investmentProgramId = investmentProgram.id?.uuidString {
            cell.investmentProgramId = investmentProgramId
        }
        
        if let isInvestEnable = investmentProgram.isInvestEnable {
            cell.investButton.isHidden = !isInvestEnable
        }
        
        if let isWithdrawEnable = investmentProgram.isWithdrawEnable {
            cell.withdrawButton.isHidden = !isWithdrawEnable
        }
        
        if let isEnable = investmentProgram.isEnabled {
            cell.buttonsStackView.isHidden = !isEnable
        }
        
        if let level = investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
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
