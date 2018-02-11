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
        cell.userNameLabel.text = participantViewModel.name
        
        cell.currencyLabel.isHidden = true
        cell.profileImageView.levelLabel.isHidden = true
        cell.profileImageView.flagImageView.isHidden = true
        
        if let logo = participantViewModel.avatar {
            let logoURL = URL(string: Constants.Api.basePath + "/" + logo)
            cell.profileImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.profileImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.depositLabel.text = "PLACE"
        cell.tradesLabel.text = "TRADES"
        cell.weeksLabel.text = "PROFIT"
        cell.profitLabel.text = "PROFIT %"
        
        if let place = participantViewModel.place,
            let ordersCount = participantViewModel.ordersCount,
            let totalProfit = participantViewModel.totalProfit,
            let totalProfitInPercent = participantViewModel.totalProfitInPercent {
            
            cell.depositValueLabel.text = String(describing: place)
            cell.tradesValueLabel.text = String(describing: ordersCount)
            cell.weeksValueLabel.text = String(describing: totalProfit)
            cell.profitValueLabel.text = String(describing: totalProfitInPercent) + "%"
        }
        
        
    }
}
