//
//  InRequestsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InRequestsTableViewCellViewModel {
    let programRequest: ProgramRequest
}

extension InRequestsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InRequestsTableViewCell) {
        if let title = programRequest.title {
            cell.titleLabel.text = title
        }
        
        cell.iconImageView.image = UIImage.programPlaceholder
        
        if let color = programRequest.color {
            cell.iconImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let fileName = programRequest.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let type = programRequest.type, let programType = programRequest.programType {
            switch type {
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_invest")
                cell.statusLabel.text = "Invest"
            case .withdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
                cell.statusLabel.text = "Withdraw"
            }
            
            if type == .withdrawal, programType == .fund {
                if let fundWithdrawPercent = programRequest.fundWithdrawPercent, let valueGvt = programRequest.valueGvt {
                    let currency: CurrencyType = .gvt
                    let text = "\(fundWithdrawPercent)% (≈" + valueGvt.rounded(withType: currency).toString() + " " + Constants.gvtString + ")"
                    cell.amountValueLabel.text = text
                }
            } else {
                switch type {
                case .invest:
                    cell.amountValueLabel.text = "-"
                case .withdrawal:
                    cell.amountValueLabel.text = "+"
                }
                
                if let value = programRequest.value, let programCurrency = programRequest.currency, let currency = CurrencyType(rawValue: programCurrency.rawValue) {
                    let text = cell.amountValueLabel.text ?? ""
                    cell.amountValueLabel.text = text + value.rounded(withType: currency).toString() + " \(currency.rawValue)"
                }
            }
        }
        
        if let date = programRequest.date {
            cell.dateLabel.text = date.onlyDateFormatString
        }
    }
}
