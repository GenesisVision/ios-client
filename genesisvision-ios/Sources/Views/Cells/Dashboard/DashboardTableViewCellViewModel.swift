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
    let investmentProgram: InvestmentProgramDashboardInvestor
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: ProgramDetailViewControllerProtocol?
}

extension DashboardTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardTableViewCell) {
        cell.chartView.isHidden = true
        cell.noDataLabel.isHidden = false
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = investmentProgram.equityChart, let title = investmentProgram.title, chart.count > 1 {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartByDateDataSet: chart, name: title, currencyValue: investmentProgram.currency?.rawValue, chartDurationType: .day)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8

        if let title = investmentProgram.title {
            cell.programTitleLabel.text = title
        }
        
        if let managerName = investmentProgram.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        if let tokenSymbol = investmentProgram.token?.tokenSymbol {
            cell.tokenSymbolLabel.text = tokenSymbol
        }
        
        if let tokensCount = investmentProgram.investedTokens {
            cell.tokensCountValueLabel.text = tokensCount.toString()
            cell.investedTokens = tokensCount
        }
        
        if let profitFromProgram = investmentProgram.profitFromProgram {
            cell.profitValueLabel.text = profitFromProgram.toString()
            cell.profitValueLabel.textColor = profitFromProgram >= 0 ? UIColor.Cell.title : UIColor.Font.red
        }
        
        cell.profitTitleLabel.text = "MY PROFIT"
        
        if let currency = investmentProgram.currency {
            cell.currencyLabel.text = currency.rawValue.uppercased()
        }
        
        if let investmentProgramId = investmentProgram.id?.uuidString {
            cell.investmentProgramId = investmentProgramId
        }
        
        if let level = investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
        }
        
        if let isFavorite = investmentProgram.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = investmentProgram.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        if let isEnabled = investmentProgram.isEnabled {
            guard let endOfPeriod = investmentProgram.endOfPeriod else { return }
            
            cell.endOfPeriod = endOfPeriod
            
            cell.isEnable = isEnabled
        }
        
        cell.reloadDataProtocol = reloadDataProtocol
        
        cell.tournamentActive(investmentProgram.isTournament ?? false)
        
        if let place = investmentProgram.place {
            cell.placeLabel.text = place.toString()
        }
    }
}
