//
//  FundTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct FundTableViewCellViewModel {
    let asset: FundDetails
    weak var delegate: FavoriteStateChangeProtocol?
}

extension FundTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        setupFundBottomView(on: cell)
        
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
        
        cell.assetLogoImageView.levelButton.isHidden = true
        cell.currencyLabel.isHidden = true
        
        cell.periodLeftProgressView.isHidden = true
        
        cell.firstTitleLabel.text = "Balance"
        if let balance = asset.statistic?.balanceGVT, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            cell.firstValueLabel.text = amount.rounded(withType: currency, specialForGVT: true).toString() + " " + currency.rawValue
        } else {
            cell.firstValueLabel.text = ""
        }
        
        
        cell.secondTitleLabel.text = "Investors"
        if let investorsCount = asset.statistic?.investorsCount {
            cell.secondValueLabel.text = investorsCount.toString()
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "D.down"
        if let drawdownPercent = asset.statistic?.drawdownPercent {
            cell.thirdValueLabel.text = drawdownPercent.rounded(withType: .undefined).toString() + "%"
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
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.fundPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            cell.profitPercentLabel.text = sign + profitPercent.rounded(withType: .undefined).toString() + "%"
            cell.profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        cell.profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            cell.investedImageView.isHidden = !isInvested
        }
    }
    
    func setupFundBottomView(on cell: ProgramTableViewCell) {
        guard let totalAssetsCount = asset.totalAssetsCount, totalAssetsCount > 0, let topFundAssets = asset.topFundAssets else { return }
        
        cell.fundBottomStackView.isHidden = false
        
        cell.firstFundAssetView.isHidden = true
        if let logo = topFundAssets[0].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[0].percent {
            cell.firstFundAssetView.isHidden = false
            cell.firstFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            cell.firstFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            cell.firstFundAssetView.assetPercentLabel.text = percent.rounded(withType: .undefined).toString() + "%"
        }
        
        cell.secondFundAssetView.isHidden = true
        if totalAssetsCount > 1, let logo = topFundAssets[1].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[1].percent {
            cell.secondFundAssetView.isHidden = false
            cell.secondFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            cell.secondFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            cell.secondFundAssetView.assetPercentLabel.text = percent.rounded(withType: .undefined).toString() + "%"
        }
        
        cell.thirdFundAssetView.isHidden = true
        if totalAssetsCount > 2, let logo = topFundAssets[2].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[2].percent {
            cell.thirdFundAssetView.isHidden = false
            cell.thirdFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            cell.thirdFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            cell.thirdFundAssetView.assetPercentLabel.text = percent.rounded(withType: .undefined).toString() + "%"
        }

        cell.otherFundAssetView.isHidden = true
        if totalAssetsCount > 3 {
            cell.otherFundAssetView.isHidden = false
            cell.otherFundAssetView.assetPercentLabel.text = "+\(totalAssetsCount - 3)"
        }
    }
}
