//
//  DashboardFundTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct DashboardFundTableViewCellViewModel {
    let fund: FundDetails
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: FavoriteStateChangeProtocol?
}

extension DashboardFundTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        
        cell.bottomStackView.isHidden = true
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText

        if let chart = fund.chart {
            cell.chartView.isHidden = false
            cell.noDataLabel.isHidden = true
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.chartView.setup(chartType: .default, lineChartData: chart)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = fund.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = fund.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let fundId = fund.id?.uuidString {
            cell.assetId = fundId
        }
        
        cell.assetLogoImageView.levelButton.isHidden = true
        cell.currencyLabel.isHidden = true
        
        cell.periodLeftProgressView.isHidden = true
        
        cell.firstTitleLabel.text = "Balance"
        if let balance = fund.statistic?.balanceGVT, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            cell.firstValueLabel.text = amount.rounded(withType: currency).toString() + " " + currency.rawValue
        } else {
            cell.firstValueLabel.text = ""
        }
        
        
        cell.secondTitleLabel.text = "Investors"
        if let investorsCount = fund.statistic?.investorsCount {
            cell.secondValueLabel.text = investorsCount.toString()
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "D.down"
        if let drawdownPercent = fund.statistic?.drawdownPercent {
            cell.thirdValueLabel.text = drawdownPercent.rounded(withType: .undefined).toString() + "%"
        } else {
            cell.thirdValueLabel.text = ""
        }
        
        
        cell.favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = fund.personalDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.fundPlaceholder
        
        if let logo = fund.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
        }
        
        if let color = fund.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let profitPercent = fund.statistic?.profitPercent {
            cell.profitPercentLabel.text = profitPercent.rounded(withType: .undefined).toString() + "%"
        }
        
        cell.profitValueLabel.isHidden = true
        
        if let isInvested = fund.personalDetails?.isInvested {
            cell.investedImageView.isHidden = !isInvested
        }
    }
}
