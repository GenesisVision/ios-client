//
//  InvestmentProgramTableViewCellModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct TraderTableViewCellViewModel {
    let investmentProgramEntity: InvestmentProgramEntity
}

extension TraderTableViewCellViewModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.userNameLabel.text = investmentProgramEntity.nickname
        cell.currencyLabel.text = investmentProgramEntity.currency.uppercased()
        
        cell.profileImageView.levelLabel.text = "\(investmentProgramEntity.rating)"
        if let logo = investmentProgramEntity.logo {
            let url = URL(string: logo)
            let placeholder = #imageLiteral(resourceName: "gv_logo")
            cell.profileImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.profileImageView.profilePhotoImageView.kf.setImage(with: url, placeholder: placeholder)
        }
        
        cell.depositLabel.text = "" + investmentProgramEntity.currency.uppercased()
        cell.tradesLabel.text = "\(investmentProgramEntity.ordersCount)"
        cell.weeksLabel.text = "\(investmentProgramEntity.period)"
        cell.profitLabel.text = "\(investmentProgramEntity.totalProfit)"
    }
}
