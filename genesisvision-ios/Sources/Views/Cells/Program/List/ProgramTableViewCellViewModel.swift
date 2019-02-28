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
    let isRating: Bool
    weak var delegate: FavoriteStateChangeProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        setupTagsBottomView(on: cell)
        
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
        
        cell.assetLogoImageView.levelButton.setImage(nil, for: .normal)
        cell.assetLogoImageView.levelButton.setTitle(nil, for: .normal)
        
        cell.bgColor = UIColor.Cell.bg
        
        cell.ratingPlaceHeightConstraint.constant = isRating ? 24.0 : 0.0
        
        if let level = asset.level {
            if isRating, let rating = asset.rating, let canLevelUp = rating.canLevelUp, canLevelUp {
                cell.assetLogoImageView.levelButton.setImage(#imageLiteral(resourceName: "img_arrow_up_rating"), for: .normal)
                cell.assetLogoImageView.levelButton.backgroundColor = UIColor.Level.color(for: level)
                cell.bgColor = UIColor.Cell.ratingBg
            } else {
                cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
            }
        }
        
        cell.ratingLabel.isHidden = !isRating
        
        if isRating, let rating = asset.rating, let ratingPlace = rating.rating {
            cell.ratingLabel.text = ratingPlace.toString()
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
        
        
        cell.secondTitleLabel.text = "Equity"
        if let balance = asset.statistic?.balanceBase, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            cell.secondValueLabel.text = amount.rounded(withType: currency, short: true).toString() + " " + currency.rawValue
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "Av. to invest"
        if let availableInvestment = asset.availableInvestmentBase, let currency = asset.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            cell.thirdValueLabel.text = availableInvestment.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
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
        
//        if let profitValue = asset.statistic?.profitValue {
//            cell.profitValueLabel.text = profitValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
//        }
        
        cell.profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            cell.investedImageView.isHidden = !isInvested
        }
    }
    
    func setupTagsBottomView(on cell: ProgramTableViewCell) {
        guard let tags = asset.tags, !tags.isEmpty else { return }
        
        let tagsCount = tags.count
        cell.tagsBottomStackView.isHidden = false
        
        cell.firstTagLabel.isHidden = true
        if let name = tags[0].name, let color = tags[0].color {
            cell.firstTagLabel.isHidden = false
            cell.firstTagLabel.text = name.uppercased()
            cell.firstTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            cell.firstTagLabel.textColor = UIColor.hexColor(color)
        }
        
        cell.secondTagLabel.isHidden = true
        if tagsCount > 1, let name = tags[1].name, let color = tags[1].color {
            cell.secondTagLabel.isHidden = false
            cell.secondTagLabel.text = name.uppercased()
            cell.secondTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            cell.secondTagLabel.textColor = UIColor.hexColor(color)
        }
        
        cell.thirdTagLabel.isHidden = true
        if tagsCount > 2, let name = tags[2].name, let color = tags[2].color {
            cell.thirdTagLabel.isHidden = false
            cell.thirdTagLabel.text = name.uppercased()
            cell.thirdTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            cell.thirdTagLabel.textColor = UIColor.hexColor(color)
        }
        
        cell.otherTagLabel.isHidden = true
        if tagsCount > 3 {
            cell.otherTagLabel.isHidden = false
            cell.otherTagLabel.text = "+\(tagsCount - 3)"
            cell.otherTagLabel.backgroundColor = UIColor.Common.green.withAlphaComponent(0.1)
            cell.otherTagLabel.textColor = UIColor.Common.green
        }
    }
}
