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
        
//        if let chart = investmentProgram.chart, chart.count > 0 {
//            cell.chartView.isHidden = false
//            cell.noDataLabel.isHidden = true
//            cell.chartView.setup(dataSet: participantViewModel.chart, name: participantViewModel.name)
//        }
        
        if let title = investmentProgram.title {
            cell.userNameLabel.text = title
        }
        
        if let currency = investmentProgram.currency {
            cell.currencyLabel.text = currency.rawValue.uppercased()
        }
        
        if let level = investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = String(describing: level)
        }
        
        cell.programLogoImageView.flagImageView.isHidden = true
        
        if let logo = investmentProgram.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.programDetailsView.setup(investorsCount: investmentProgram.investorsCount, balance: investmentProgram.balance, avrProfit: investmentProgram.profitAvg, totalProfit: investmentProgram.profitTotal)
    }
}
