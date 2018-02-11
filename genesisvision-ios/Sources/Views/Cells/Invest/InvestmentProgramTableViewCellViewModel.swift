//
//  InvestmentProgramTableViewCellModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct InvestmentProgramTableViewCellViewModel {
    let investmentProgramEntity: InvestmentProgramEntity
}

extension InvestmentProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.userNameLabel.text = investmentProgramEntity.nickname
        cell.currencyLabel.text = investmentProgramEntity.currency.uppercased()
        
        cell.profileImageView.levelLabel.text = "\(investmentProgramEntity.getRating())"
        cell.profileImageView.flagImageView.isHidden = true
        
        if let logo = investmentProgramEntity.logo {
            let logoURL = URL(string: logo)
            cell.profileImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.profileImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.depositLabel.text = "DEPOSIT"
        cell.tradesLabel.text = "TRADES"
        cell.weeksLabel.text = "WEEKS"
        cell.profitLabel.text = "PROFIT %"
        
        cell.depositLabel.text = investmentProgramEntity.currency.uppercased()
        cell.tradesLabel.text = String(describing: investmentProgramEntity.ordersCount)
        cell.weeksLabel.text = String(describing: investmentProgramEntity.period)
        cell.profitLabel.text = String(describing: investmentProgramEntity.totalProfit) + "%"
    }
}
