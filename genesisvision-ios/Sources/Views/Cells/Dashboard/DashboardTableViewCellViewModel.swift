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
            cell.chartView.setup(chartType: .default, lineChartData: chart, name: title, currencyValue: program.currency?.rawValue, chartDurationType: .all)
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
            cell.statusButton.layoutSubviews()
        }
    
        if let programId = program.id?.uuidString {
            cell.programId = programId
        }
        
        if let level = program.level {
            cell.programLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let currency = program.currency {
            cell.currencyLabel.text = currency.rawValue
        }
        
        if let periodStarts = program.periodStarts, let periodEnds = program.periodEnds, let periodDuration = program.periodDuration {
            cell.firstTitleLabel.text = "period"
            cell.firstValueLabel.text = periodEnds.timeSinceDate(fromDate: periodStarts)
            
            let today = Date()
            if let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        }
        
        if let balance = program.statistic?.balanceGVT?.amount {
            cell.secondTitleLabel.text = "balance"
            cell.secondValueLabel.text = balance.rounded(withType: .gvt).toString() + " GVT"
        }
        
        if let share = program.dashboardProgramDetails?.share {
            cell.thirdTitleLabel.text = "share"
            cell.thirdValueLabel.text = share.rounded(toPlaces: 2).toString() + "%"
        }
        
        if let isFavorite = program.personalProgramDetails?.isFavorite {
            cell.favoriteButton.isSelected = isFavorite
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = program.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.placeholder)
        }
    }
}
