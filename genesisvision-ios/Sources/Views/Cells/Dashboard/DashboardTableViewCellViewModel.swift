//
//  DashboardTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct DashboardTableViewCellViewModel {
    let program: ProgramDetails
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: ProgramDetailViewControllerProtocol?
}

extension DashboardTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.bottomStackView.isHidden = false
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
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
        
        if let managerName = program.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let status = program.status {
            cell.statusButton.setTitle(status.rawValue, for: .normal)
        }
        
//        if let tokenSymbol = program.token?.tokenSymbol {
//            cell.tokenSymbolLabel.text = tokenSymbol
//        }
        
//        if let tokensCount = program.investedTokens {
//            cell.tokensCountValueLabel.text = tokensCount.toString()
//            cell.investedTokens = tokensCount
//        }
        
//        if let profitFromProgram = program.profitFromProgram {
//            cell.profitValueLabel.text = profitFromProgram.toString()
//            cell.profitValueLabel.textColor = profitFromProgram >= 0 ? UIColor.Cell.title : UIColor.Font.red
//        }
//
//        cell.profitTitleLabel.text = "MY PROFIT"
    
        if let programId = program.id?.uuidString {
            cell.programId = programId
        }
        
        if let level = program.level {
            cell.programLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let isFavorite = program.personalProgramDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = program.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.placeholder)
        }
        
//        if let isEnabled = program.isEnabled {
//            guard let endOfPeriod = program.endOfPeriod else { return }
//
//            cell.endOfPeriod = endOfPeriod
//
//            cell.isEnable = isEnabled
//        }
    }
}
