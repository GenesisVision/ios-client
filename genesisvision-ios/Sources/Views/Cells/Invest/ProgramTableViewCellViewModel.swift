//
//  ProgramTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct ProgramTableViewCellViewModel {
    let investmentProgram: InvestmentProgram
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        
        cell.noDataLabel.text = "Not enough data"
        
//        if let chart = participantViewModel.chart, chart.count > 0 {
//            cell.chartView.isHidden = false
//            cell.noDataLabel.isHidden = true
//            cell.chartView.setup(dataSet: participantViewModel.chart, name: participantViewModel.name)
//        }
        
        var currency = Currency.gvt.rawValue.uppercased()
        var username = ""
        
        if let account = investmentProgram.account {
            username = account.login ?? ""
            currency = account.currency?.uppercased() ?? ""
        }
        
        guard let investment = investmentProgram.investment else {
            return
        }
        
        cell.userNameLabel.text = username
        cell.currencyLabel.text = currency
        
        if let rating = investment.rating {
            cell.profileImageView.levelLabel.text = String(describing: Int(rating))
        }
        
        cell.profileImageView.flagImageView.isHidden = true
        
        if let logo = investment.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.profileImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.profileImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
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
