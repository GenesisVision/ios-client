//
//  DashboardSignalTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct SignalTableViewCellViewModel {
    let signal: SignalDetails
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: FavoriteStateChangeProtocol?
}

extension SignalTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.dashboardBottomStackView.isHidden = true
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        cell.reinvestStackView.isHidden = true
        
        if let chart = signal.chart {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = signal.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = signal.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let programId = signal.id?.uuidString {
            cell.assetId = programId
        }
        
        if let level = signal.level {
            cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let currency = signal.currency {
            cell.currencyLabel.text = currency.rawValue
        }
        
        cell.firstTitleLabel.text = "trades"
        if let tradesCount = signal.personalDetails?.tradesCount {
            cell.periodLeftProgressView.isHidden = true
            cell.firstValueLabel.text = tradesCount.toString()
        } else {
            cell.firstValueLabel.text = ""
        }
        
        cell.secondTitleLabel.text = "subscribers"
        if let subscribers = signal.subscribers {
            cell.secondValueLabel.text = subscribers.toString()
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "start date"
        if let subscriptionDate = signal.personalDetails?.subscriptionDate {
            cell.thirdValueLabel.text = subscriptionDate.dateAndTimetoString()
        } else {
            cell.thirdValueLabel.text = ""
        }
        
        if let color = signal.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = signal.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = signal.personalDetails?.profit {
            let sign = profitPercent > 0 ? "+" : ""
            cell.profitPercentLabel.text = sign + profitPercent.rounded(withType: .undefined).toString() + "%"
            cell.profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        cell.profitValueLabel.isHidden = true
    }
}

