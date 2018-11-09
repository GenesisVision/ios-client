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
    let program: ProgramDetails
    weak var delegate: FavoriteStateChangeProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = program.chart {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartType: .default, lineChartData: chart, dateRangeType: PlatformManager.shared.dateRangeType, dateFrom: PlatformManager.shared.dateFrom, dateTo: PlatformManager.shared.dateTo)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = program.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = program.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let programId = program.id?.uuidString {
            cell.assetId = programId
        }
        
        if let level = program.level {
            cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let currency = program.currency {
            cell.currencyLabel.text = currency.rawValue
        }
        
        cell.firstTitleLabel.text = "Period"
        if let periodStarts = program.periodStarts, let periodEnds = program.periodEnds, let periodDuration = program.periodDuration {
            cell.firstValueLabel.text = periodDuration.toString() + (periodDuration > 1 ? " days" : " day")
            
            let today = Date()
            if let periodDuration = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate:periodStarts).minute, let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            cell.firstValueLabel.text = ""
        }
        
        
        cell.secondTitleLabel.text = "Balance"
        if let balance = program.statistic?.balanceGVT, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            cell.secondValueLabel.text = amount.rounded(withType: currency, specialForGVT: true).toString() + " " + currency.rawValue
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "Av. to invest"
        if let availableInvestment = program.availableInvestment {
            cell.thirdValueLabel.text = availableInvestment.rounded(withType: .gvt, specialForGVT: true).toString() + " \(Constants.gvtString)"
        } else {
            cell.thirdValueLabel.text = ""
        }
        
        
        cell.favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = program.personalDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        if let color = program.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = program.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = program.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            cell.profitPercentLabel.text = sign + profitPercent.rounded(withType: .undefined).toString() + "%"
            cell.profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        if let profitValue = program.statistic?.profitValue {
            cell.profitValueLabel.text = profitValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        if let isInvested = program.personalDetails?.isInvested {
            cell.investedImageView.isHidden = !isInvested
        }
    }
}
