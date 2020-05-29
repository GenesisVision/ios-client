//
//  EventCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct EventCollectionViewCellViewModel {
    weak var reloadDataProtocol: ReloadDataProtocol?
    let event: InvestmentEventViewModel
}

extension EventCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: EventCollectionViewCell) {
        cell.iconImageView.image = UIImage.eventPlaceholder
        if let fileName = event.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
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
        
        if let fileName = event.assetDetails?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
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
            cell.balanceStackView.isHidden = false
            
            cell.balanceValueLabel.text = amount.rounded(with: currencyType).toString() + " \(currencyType.rawValue)"
            
            cell.balanceValueLabel.textColor = UIColor.Cell.title
        } else if let amount = event.amount,
            let currency = event.currency,
            let currencyType = CurrencyType(rawValue: currency.rawValue),
            let changeState = event.changeState {
            cell.balanceStackView.isHidden = false
            
            cell.balanceValueLabel.text = amount.rounded(with: currencyType).toString() + " \(currencyType.rawValue)"
            
            switch changeState {
            case .increased:
                cell.balanceValueLabel.textColor = UIColor.Cell.greenTitle
            case .decreased:
                cell.balanceValueLabel.textColor = UIColor.Cell.redTitle
            default:
                cell.balanceValueLabel.textColor = UIColor.Cell.title
            }
        } else {
            cell.balanceStackView.isHidden = true
        }
        
        if let date = event.date {
            cell.dateLabel.text = date.dateAndTimeFormatString
        }
    }
}

