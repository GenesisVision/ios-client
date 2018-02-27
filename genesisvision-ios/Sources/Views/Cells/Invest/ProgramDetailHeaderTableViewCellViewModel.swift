//
//  ProgramDetailHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 19.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct ProgramDetailHeaderTableViewCellViewModel {
    let investment: Investment
}

extension ProgramDetailHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailHeaderTableViewCell) {
        if let rating = investment.rating {
            cell.programLogoImageView.levelLabel.text = String(describing: Int(rating))
        }
        
        cell.programLogoImageView.flagImageView.isHidden = true
        
        if let logo = investment.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.depositLabel.text = "LAST PERIOD"
        cell.tradesLabel.text = "TRADES"
        cell.weeksLabel.text = "WEEKS"
        cell.profitLabel.text = "PROFIT %"
        
        cell.depositLabel.textColor = UIColor.Font.dark
        cell.tradesLabel.textColor = UIColor.Font.medium
        cell.weeksLabel.textColor = UIColor.Font.medium
        cell.profitLabel.textColor = UIColor.Font.dark
        
        if let lastPeriod = investment.lastPeriod?.number,
            let trades = investment.ordersCount,
            let totalProfit = investment.totalProfit,
            let weeks = investment.period {
            
            let totalProfitValue = Double(round(100 * totalProfit) / 100)
            
            cell.depositValueLabel.text = String(describing: lastPeriod)
            cell.tradesValueLabel.text = String(describing: trades)
            cell.weeksValueLabel.text = String(describing: weeks)
            cell.profitValueLabel.text = String(describing: totalProfitValue) + "%"
            
            cell.depositValueLabel.textColor = UIColor.primary
            cell.tradesValueLabel.textColor = UIColor.Font.medium
            cell.weeksValueLabel.textColor = UIColor.Font.medium
            cell.profitValueLabel.textColor = totalProfitValue == 0 ? UIColor.Font.medium : totalProfitValue >= 0 ? UIColor.Font.green : UIColor.Font.red
        }
    }
}

