//
//  TraderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct TraderTableViewCellViewModel {
    let participantViewModel: ParticipantViewModel
}

extension TraderTableViewCellViewModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        
        cell.noDataLabel.text = "Not enough data"
        
        if let chart = participantViewModel.chart, chart.count > 0 {
            cell.chartView.isHidden = false
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(dataSet: participantViewModel.chart, name: participantViewModel.name)
        }
        
        cell.userNameLabel.text = participantViewModel.name ?? ""
        
        cell.currencyLabel.isHidden = true
        cell.programLogoImageView.levelLabel.isHidden = true
        cell.programLogoImageView.flagImageView.isHidden = true
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = participantViewModel.avatar {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.depositLabel.text = "PLACE"
        cell.tradesLabel.text = "TRADES"
        cell.weeksLabel.text = "PROFIT"
        cell.profitLabel.text = "PROFIT %"
        
        cell.depositLabel.textColor = UIColor.Font.dark
        cell.tradesLabel.textColor = UIColor.Font.medium
        cell.weeksLabel.textColor = UIColor.Font.medium
        cell.profitLabel.textColor = UIColor.Font.dark
        
        if let place = participantViewModel.place,
            let ordersCount = participantViewModel.ordersCount,
            let totalProfit = participantViewModel.totalProfit,
            let totalProfitInPercent = participantViewModel.totalProfitInPercent {
            
            let totalProfitValue = Double(round(100 * totalProfit) / 100)
            let totalProfitInPercentValue = Double(round(100 * totalProfitInPercent) / 100)
                
            cell.depositValueLabel.text = String(describing: place)
            cell.tradesValueLabel.text = String(describing: ordersCount)
            cell.weeksValueLabel.text = String(describing: totalProfitValue)
            cell.profitValueLabel.text = String(describing: totalProfitInPercentValue) + "%"
            
            cell.depositValueLabel.textColor = UIColor.primary
            cell.tradesValueLabel.textColor = UIColor.Font.medium
            cell.weeksValueLabel.textColor = UIColor.Font.medium
            cell.profitValueLabel.textColor = totalProfitInPercent == 0 ? UIColor.Font.medium : totalProfitInPercent >= 0 ? UIColor.Font.green : UIColor.Font.red
        }
    }
}
