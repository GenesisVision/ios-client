//
//  PortfolioEventTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct PortfolioEventTableViewCellViewModel {
    let event: InvestmentEventViewModel
}

extension PortfolioEventTableViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioEventTableViewCell) {
        cell.iconImageView.image = UIImage.programPlaceholder
        
        if let fileName = event.icon, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let fileName = event.assetDetails?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.typeImageView.kf.indicatorType = .activity
            cell.typeImageView.kf.setImage(with: fileUrl, placeholder: UIImage.eventPlaceholder)
        }
        
        if let title = event.title {
            cell.titleLabel.text = title
        }
        
        if let value = event.amount, let currency = event.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            cell.amountLabel.text = value.rounded(withType: currencyType).toString() + " \(currencyType.rawValue)"
            cell.amountLabel.textColor = value == 0
                ? UIColor.Cell.subtitle
                : value > 0
                    ? UIColor.Cell.greenTitle
                    : UIColor.Cell.redTitle
        }
        
        if let date = event.date {
            cell.dateLabel.text = date.onlyTimeFormatString
        }
    }
}

