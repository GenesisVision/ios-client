//
//  PortfolioEventTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct PortfolioEventTableViewCellViewModel {
    let dashboardPortfolioEvent: DashboardPortfolioEvent
}

extension PortfolioEventTableViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioEventTableViewCell) {
        cell.iconImageView.image = UIImage.programPlaceholder
        
        if let color = dashboardPortfolioEvent.color {
            cell.iconImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let fileName = dashboardPortfolioEvent.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let type = dashboardPortfolioEvent.type {
            switch type {
            case .profit:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_profit")
            case .loss:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_loss")
            case .withdraw:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_invest")
            case .all:
                cell.typeImageView.image = nil
            case .reinvest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_reinvest")
            case .cancelled:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_canceled")
            case .ended:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_program_finished")
            }
        }
            
        if let title = dashboardPortfolioEvent.description {
            cell.titleLabel.text = title
        }
        
        if let value = dashboardPortfolioEvent.value, let currency = dashboardPortfolioEvent.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) {
            cell.amountLabel.text = value.rounded(withType: programCurrency).toString() + " \(programCurrency.rawValue)"
            cell.amountLabel.textColor = value == 0
                ? UIColor.Cell.subtitle
                : value > 0
                    ? UIColor.Cell.greenTitle
                    : UIColor.Cell.redTitle
        }
        
        if let date = dashboardPortfolioEvent.date {
            cell.dateLabel.text = date.defaultFormatString
        }
    }
}

