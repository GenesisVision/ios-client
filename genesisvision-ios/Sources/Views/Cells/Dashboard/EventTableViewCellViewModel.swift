//
//  PortfolioEventTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct EventTableViewCellViewModel {
    let event: InvestmentEventViewModel
}

extension EventTableViewCellViewModel: CellViewModel {
    func setup(on cell: EventTableViewCell) {
        cell.iconImageView.image = UIImage.eventPlaceholder
        if let fileName = event.icon, let fileUrl = getFileURL(fileName: fileName) {
            cell.typeImageView.kf.indicatorType = .activity
            cell.typeImageView.kf.setImage(with: fileUrl, placeholder: UIImage.eventPlaceholder)
        }
        
        if let color = event.assetDetails?.color {
            cell.iconImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let type = event.assetDetails?.assetType {
            switch type {
            case .fund:
                cell.iconImageView.image = UIImage.fundPlaceholder
            default:
                cell.iconImageView.image = UIImage.programPlaceholder
            }
        }
        
        if let fileName = event.assetDetails?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let title = event.title {
            cell.titleLabel.text = title
        }
        
        if let extendedInfo = event.extendedInfo?.first,
            let amount = extendedInfo.amount,
            let currency = extendedInfo.currency,
            let currencyType = CurrencyType(rawValue: currency.rawValue) {
            let text = amount.rounded(with: currencyType).toString() + " \(currencyType.rawValue)"
            cell.amountLabel.text = text
            cell.amountLabel.textColor = UIColor.Cell.title
            cell.amountLabel.isHidden = false
        } else if let amount = event.amount, let currency = event.currency, let currencyType = CurrencyType(rawValue: currency.rawValue), let changeState = event.changeState {
            let text = amount.rounded(with: currencyType).toString() + " \(currencyType.rawValue)"
            cell.amountLabel.text = text
            cell.amountLabel.isHidden = false
            switch changeState {
            case .increased:
                cell.amountLabel.textColor = UIColor.Cell.greenTitle
            case .decreased:
                cell.amountLabel.textColor = UIColor.Cell.redTitle
            default:
                cell.amountLabel.textColor = UIColor.Cell.title
            }
        } else {
            cell.amountLabel.isHidden = true
        }
        
        if let date = event.date {
            cell.dateLabel.text = date.onlyTimeFormatString
        }
    }
}

