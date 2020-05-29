//
//  WalletTransactionTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletTransactionTableViewCellViewModel {
    let walletTransaction: TransactionViewModel
}

extension WalletTransactionTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletTransactionTableViewCell) {
        cell.iconImageView.image = UIImage.eventPlaceholder
        
        if let logo = walletTransaction.amount?.first?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.iconImageView.backgroundColor = .clear
        } else {
            cell.iconImageView.isHidden = true
        }

        cell.amountLabel.text = ""
        
        if let amount = walletTransaction.amount?.first?.amount, let currencyFrom = walletTransaction.amount?.first?.currency, let currency = CurrencyType(rawValue: currencyFrom.rawValue) {
            cell.amountLabel.text = amount.rounded(with: currency).toString() + " " + currency.rawValue

            cell.amountLabel.textColor = amount == 0 ? UIColor.Cell.title : amount > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        } else {
            cell.amountLabel.isHidden = true
        }
        
        if walletTransaction.amount?.second != nil {
            cell.amountLabel.textColor = UIColor.Cell.title
        }
        
        if let information = walletTransaction._description {
            cell.titleLabel.text = information
        } else {
            cell.titleLabel.isHidden = true
        }
        
        if let status = walletTransaction.status {
            cell.statusLabel.text = status.rawValue
            
            switch status {
                case .canceled, .error:
                    cell.statusLabel.textColor = UIColor.Cell.redTitle
                case .done:
                    cell.statusLabel.textColor = UIColor.Cell.greenTitle
                case .pending:
                    cell.statusLabel.textColor = UIColor.Cell.yellowTitle
            }
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
