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
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.noDataLabel.isHidden = false
        
        cell.noDataLabel.text = Constants.ErrorMessages.noDataText
        
        if let chart = participantViewModel.chart, chart.count > 1 {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(dataSet: [], name: participantViewModel.name)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let name = participantViewModel.name {
            cell.programTitleLabel.text = name
        }
        
        cell.currencyLabel.isHidden = true
        cell.programLogoImageView.levelLabel.isHidden = true
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = participantViewModel.avatar {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.programDetailsView.setup(with: "PLACE", investorsCount: participantViewModel.place, balanceTitle: "TRADES", balance: Double(participantViewModel.ordersCount ?? 0), avgProfitTitle: "PROFIT", avgProfit: participantViewModel.totalProfit, totalProfitTitle: "PROFIT", totalProfit: participantViewModel.totalProfitInPercent, currency: nil)
    }
}
