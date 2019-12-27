//
//  InRequestsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InRequestsTableViewCellViewModel {
    let request: AssetInvestmentRequest
}

extension InRequestsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InRequestsTableViewCell) {
        if let title = request.assetDetails?.title {
            cell.titleLabel.text = title
        }
        
        cell.iconImageView.image = UIImage.programPlaceholder
        
        if let color = request.assetDetails?.color {
            cell.iconImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let fileName = request.assetDetails?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let type = request.type, let assetType = request.assetDetails?.assetType {
            cell.statusLabel.text = type.rawValue
            
            switch type {
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_invest")
            case .withdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
            }
            
            var text = ""
            if type == .withdrawal, assetType == .fund {
                if let amount = request.amount, let currencyValue = request.currency?.rawValue, let currency: CurrencyType = CurrencyType(rawValue: currencyValue) {
                    text = amount.rounded(with: currency).toString() + " " + currencyValue
                }
            } else {
                switch type {
                case .invest:
                    text = "-"
                case .withdrawal:
                    text = "+"
                }
                
                if let amount = request.amount, let currencyValue = request.currency?.rawValue, let currency: CurrencyType = CurrencyType(rawValue: currencyValue) {
                    text = text + amount.rounded(with: currency).toString() + " " + currencyValue
                }
            }
            
            cell.amountValueLabel.text = text
        }
        
        if let date = request.date {
            cell.dateLabel.text = date.onlyDateFormatString
        }
    }
}
