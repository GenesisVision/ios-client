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
    let program: ProgramDetailsFull
    weak var delegate: ProgramDetailViewControllerProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.chartView.isHidden = true
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.noDataLabel.isHidden = false
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
//        if let chart = program.equityChart, let title = program.title, chart.count > 1 {
//            cell.chartView.isHidden = false
//            cell.viewForChartView.isHidden = cell.chartView.isHidden
//            cell.noDataLabel.isHidden = true
//            cell.chartView.setup(chartByDateDataSet: chart, name: title, currencyValue: program.currency?.rawValue)
//        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = program.title {
            cell.programTitleLabel.text = title
        }
        
        if let programId = program.id?.uuidString {
            cell.programId = programId
        }
        
        if let managerName = program.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let isFavorite = program.personalProgramDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.favoriteButton.isHidden = !AuthManager.isLogin()
        
//        if let availableInvestment = program.availableInvestment {
//            cell.noAvailableTokensLabel.isHidden = availableInvestment > 0
//        }
        
        if let currency = program.currency, let currencyType = CurrencyType(currency: Constants.currency) {
            cell.currencyLabel.currencyType = currencyType
            cell.currencyLabel.text = currency.rawValue.uppercased()
        }
        
        if let level = program.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = program.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.programDetailsView.setup(investorsCount: program.statistic?.investorsCount, balance: program.statistic?.balanceGVT?.amount, avgProfit: program.statistic?.profitPercent, totalProfit: program.statistic?.profitValue, currency: program.currency?.rawValue)
        
        cell.tournamentActive(false)
    }
}
