//
//  DetailHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct DetailHeaderTableViewCellViewModel {
    let participantViewModel: ParticipantViewModel
}

extension DetailHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailHeaderTableViewCell) {
        cell.profileImageView.levelLabel.isHidden = true
        cell.profileImageView.flagImageView.isHidden = true
        
        if let logo = participantViewModel.avatar {
            let logoURL = getFileURL(fileName: logo)
            cell.profileImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.profileImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
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
            
            cell.depositValueLabel.text = String(describing: place)
            cell.tradesValueLabel.text = String(describing: ordersCount)
            cell.weeksValueLabel.text = String(describing: totalProfit)
            cell.profitValueLabel.text = String(describing: totalProfitInPercent) + "%"
            
            cell.depositValueLabel.textColor = UIColor.primary
            cell.tradesValueLabel.textColor = UIColor.Font.medium
            cell.weeksValueLabel.textColor = UIColor.Font.medium
            cell.profitValueLabel.textColor = totalProfitInPercent >= 0 ? UIColor.Font.green : UIColor.Font.red
        }
    }
}
