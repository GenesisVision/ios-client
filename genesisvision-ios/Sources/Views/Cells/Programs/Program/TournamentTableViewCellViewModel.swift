//
//  TournamentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct TournamentTableViewCellViewModel {
    let investmentProgram: InvestmentProgram
    weak var delegate: ProgramDetailViewControllerProtocol?
}

extension TournamentTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.chartView.isHidden = true
        cell.viewForChartView.isHidden = cell.chartView.isHidden
        cell.noDataLabel.isHidden = false
        cell.delegate = delegate
        
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = investmentProgram.equityChart, let title = investmentProgram.title, chart.count > 1 {
            cell.chartView.isHidden = false
            cell.viewForChartView.isHidden = cell.chartView.isHidden
            cell.noDataLabel.isHidden = true
            cell.chartView.setup(chartByDateDataSet: chart, name: title, currencyValue: investmentProgram.currency?.rawValue)
        }
        
        cell.stackView.spacing = cell.chartView.isHidden ? 24 : 8
        
        cell.placeLabel.isHidden = true
        cell.currencyLabel.isHidden = false
        
        if let isTournament = investmentProgram.isTournament, isTournament {
            if isTournament {
                cell.plateAppearance = PlateTableViewCellAppearance(cornerRadius: Constants.SystemSizes.cornerSize,
                                                                    horizontalMarginValue: Constants.SystemSizes.Cell.horizontalMarginValue,
                                                                    verticalMarginValues: Constants.SystemSizes.Cell.verticalMarginValues,
                                                                    backgroundColor: UIColor.Cell.tournamentBg,
                                                                    selectedBackgroundColor: UIColor.Cell.tournamentBg)
                
                if let place = investmentProgram.place {
                    cell.placeLabel.isHidden = !isTournament
                    cell.currencyLabel.isHidden = isTournament
                    
                    cell.placeLabel.text = place.toString()
                }
            }
        }
        
        if let title = investmentProgram.title {
            cell.programTitleLabel.text = title
        }
        
        if let investmentProgramId = investmentProgram.id?.uuidString {
            cell.investmentProgramId = investmentProgramId
        }
        
        if let managerName = investmentProgram.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let isFavorite = investmentProgram.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.favoriteStackView.isHidden = !AuthManager.isLogin()
        
        if let availableInvestment = investmentProgram.availableInvestment {
            cell.noAvailableTokensLabel.isHidden = availableInvestment > 0
        }
        
        if let currency = investmentProgram.currency {
            cell.currencyLabel.text = currency.rawValue.uppercased()
        }
        
        if let level = investmentProgram.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = investmentProgram.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        cell.programDetailsView.setup(investorsCount: investmentProgram.investorsCount, balance: investmentProgram.balance, avgProfit: investmentProgram.profitAvgPercent, totalProfit: investmentProgram.profitTotal, currency: investmentProgram.currency?.rawValue)
    }
}
