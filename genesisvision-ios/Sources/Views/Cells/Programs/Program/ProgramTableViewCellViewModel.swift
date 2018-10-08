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
    weak var delegate: ProgramDetailViewControllerProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.chartView.isHidden = true
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.noDataLabel.isHidden = false
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = program.chart, let title = program.title, chart.count > 1 {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartType: .default, lineChartData: chart, barChartData: nil, name: title, currencyValue: program.currency?.rawValue, chartDurationType: .all)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        if let title = program.title {
            cell.programTitleLabel.text = title
        }
        
        if let programId = program.id?.uuidString {
            cell.programId = programId
        }
        
        if let status = program.status {
            cell.statusButton.setTitle(status.rawValue, for: .normal)
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
        
        if let level = program.level {
            cell.programLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = program.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.placeholder)
        }
        
        cell.programDetailsView.setup(investorsCount: program.statistic?.investorsCount, balance: program.statistic?.balanceGVT?.amount, avgProfit: program.statistic?.profitPercent, totalProfit: program.statistic?.profitValue, currency: program.currency?.rawValue)
    }
}
