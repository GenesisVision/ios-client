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
            cell.chartView.setup(dataSet: [], name: participantViewModel.name)
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
        
        cell.programDetailsView.setup(with: "PLACE", investorsCount: participantViewModel.place, balanceTitle: "TRADES", balance: Double(participantViewModel.ordersCount ?? 0), avrProfitTitle: "PROFIT", avrProfit: participantViewModel.totalProfit, totalProfitTitle: "PROFIT %", totalProfit: participantViewModel.totalProfitInPercent)
    }
}
