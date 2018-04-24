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
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.noDataLabel.isHidden = false
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = self.investmentProgram.chart, let title = self.investmentProgram.title, chart.count > 1 {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartDataSet: chart, name: title, currencyValue: self.investmentProgram.currency?.rawValue)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = self.investmentProgram.title {
            cell.programTitleLabel.text = title
        }
        
        if let currency = self.investmentProgram.currency {
            cell.currencyLabel.text = currency.rawValue.uppercased()
        }
        
        if let level = self.investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = self.investmentProgram.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        if let isEnabled = self.investmentProgram.isEnabled,
            isEnabled,
            let freeTokens = self.investmentProgram.freeTokens,
            let total = freeTokens.total,
            let investorsTokens = freeTokens.investorsTokens,
            let requestsTokens = freeTokens.requestsTokens {
            cell.stackedProgressView.setup(totalValue: total, investedValue: investorsTokens, requestsValue: requestsTokens)
        }
        
        cell.programDetailsView.setup(investorsCount: self.investmentProgram.investorsCount, balance: self.investmentProgram.balance, avgProfit: self.investmentProgram.profitAvgPercent, totalProfit: self.investmentProgram.profitTotal, currency: self.investmentProgram.currency?.rawValue)
    }
}
