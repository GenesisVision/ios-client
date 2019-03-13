//
//  DashboardProgramTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct DashboardProgramTableViewCellViewModel {
    let program: ProgramDetails
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: FavoriteStateChangeProtocol?
    weak var reinvestProtocol: SwitchProtocol?
}

extension DashboardProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.reinvestProtocol = reinvestProtocol
        cell.dashboardBottomStackView.isHidden = false
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let isReinvesting = program.personalDetails?.isReinvest {
            cell.reinvestSwitch.isOn = isReinvesting
        }
        
        if let chart = program.chart {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = program.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = program.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let status = program.personalDetails?.status {
            cell.statusButton.handleUserInteractionEnabled = false
            cell.statusButton.setTitle(status.rawValue, for: .normal)
            cell.statusButton.layoutSubviews()
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
        
        cell.firstTitleLabel.text = "time left"
        if let periodEnds = program.periodEnds, let periodDuration = program.periodDuration {
            
            let today = Date()
            let periodLeft = periodEnds.daysSinceDate(fromDate: today)
            
            cell.firstValueLabel.text = periodLeft.isEmpty ? "0" : periodLeft
            
            if let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            cell.firstValueLabel.text = ""
        }
        
        cell.secondTitleLabel.text = "current value"
        if let value = program.personalDetails?.value, let currency = program.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            
            cell.secondValueLabel.text = value.rounded(withType: currencyType, short: true).toString() + " " + currencyType.rawValue
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "share"
        if let share = program.dashboardAssetsDetails?.share {
            cell.thirdValueLabel.text = share.rounded(withType: .undefined).toString() + "%"
        } else {
            cell.thirdValueLabel.text = ""
        }
        
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
