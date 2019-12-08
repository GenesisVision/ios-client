//
//  WalletExternalTransactionTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 13/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletExternalTransactionTableViewCellViewModel {
    let walletTransaction: MultiWalletExternalTransaction
}

extension WalletExternalTransactionTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletTransactionTableViewCell) {
        cell.iconImageView.image = UIImage.eventPlaceholder
        
        if let logo = walletTransaction.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.iconImageView.backgroundColor = .clear
        } else {
            cell.iconImageView.isHidden = true
        }
        
        cell.amountLabel.text = ""
        
        if let amount = walletTransaction.amount, let currencyFrom = walletTransaction.currency {
            if let currency = CurrencyType(rawValue: currencyFrom.rawValue) {
                cell.amountLabel.text = amount.rounded(with: currency).toString() + " " + currency.rawValue
            }
            
            if let type = walletTransaction.type {
                switch type {
                case .deposit:
                    cell.amountLabel.textColor = UIColor.Cell.greenTitle
                case .withdrawal:
                    cell.amountLabel.textColor = UIColor.Cell.redTitle
                default:
                    cell.amountLabel.textColor = UIColor.Cell.title
                }
            }
        } else {
            cell.amountLabel.isHidden = true
        }
        
        if let currency = walletTransaction.currency {
            cell.titleLabel.text = currency.rawValue
        } else {
            cell.titleLabel.isHidden = true
        }
        
        if let status = walletTransaction.status {
            cell.statusLabel.text = status
        } else {
            cell.statusLabel.isHidden = true
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        } else {
            cell.dateLabel.isHidden = true
        }
        
        cell.selectionStyle = .none
    }
}

