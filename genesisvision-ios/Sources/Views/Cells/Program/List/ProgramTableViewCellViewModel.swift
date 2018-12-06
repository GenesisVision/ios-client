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
    let asset: ProgramDetails
    weak var delegate: FavoriteStateChangeProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = asset.chart {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = asset.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let assetId = asset.id?.uuidString {
            cell.assetId = assetId
        }
        
        if let level = asset.level {
            cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let currency = asset.currency {
            cell.currencyLabel.text = currency.rawValue
        }
        
        cell.firstTitleLabel.text = "Period"
        if let periodStarts = asset.periodStarts, let periodEnds = asset.periodEnds, let periodDuration = asset.periodDuration {
            cell.firstValueLabel.text = periodDuration.toString() + (periodDuration > 1 ? " days" : " day")
            
            let today = Date()
            if let periodDuration = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate:periodStarts).minute, let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            cell.firstValueLabel.text = ""
        }
        
        
        cell.secondTitleLabel.text = "Balance"
        if let balance = asset.statistic?.balanceGVT, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            cell.secondValueLabel.text = amount.rounded(withType: currency, specialForGVT: true).toString() + " " + currency.rawValue
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "Av. to invest"
        if let availableInvestment = asset.availableInvestment {
            cell.thirdValueLabel.text = availableInvestment.rounded(withType: .gvt, specialForGVT: true).toString() + " \(Constants.gvtString)"
        } else {
            cell.thirdValueLabel.text = ""
        }
        
        
        cell.favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            cell.profitPercentLabel.text = sign + profitPercent.rounded(withType: .undefined).toString() + "%"
            cell.profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        if let profitValue = asset.statistic?.profitValue {
            cell.profitValueLabel.text = profitValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        if let isInvested = asset.personalDetails?.isInvested {
            cell.investedImageView.isHidden = !isInvested
        }
    }
}
