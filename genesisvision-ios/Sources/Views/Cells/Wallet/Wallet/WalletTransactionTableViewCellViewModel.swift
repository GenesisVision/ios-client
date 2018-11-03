//
//  WalletTransactionTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletTransactionTableViewCellViewModel {
    let walletTransaction: WalletTransaction
}

extension WalletTransactionTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletTransactionTableViewCell) {
        cell.iconImageView.image = #imageLiteral(resourceName: "img_wallet_transaction_icon")
        cell.typeImageView.image = nil

        cell.amountLabel.text = ""
        
        var sign = ""
        
        if let action = walletTransaction.action,
            let sourceType = walletTransaction.sourceType,
            let destinationType = walletTransaction.destinationType {
            
            switch action {
            case .transfer:
                if sourceType == .paymentTransaction, action == .transfer, destinationType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_invest")
                    sign = "+"
                }
                
                if sourceType == .wallet, action == .transfer, destinationType == .withdrawalRequest {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
                    sign = "-"
                }
                
                if sourceType == .withdrawalRequest, action == .transfer, destinationType == .paymentTransaction {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
                    sign = "-"
                }
            default:
                if sourceType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
                    sign = "-"
                } else if destinationType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_invest")
                    sign = "+"
                }
            }
        }
        
        if let amount = walletTransaction.amount,
            let sourceCurrency = walletTransaction.sourceCurrency {
            if let currency = CurrencyType(rawValue: sourceCurrency.rawValue) {
                cell.amountLabel.text = sign + amount.rounded(withType: currency).toString() + " " + currency.rawValue
            }
            
            cell.amountLabel.textColor = sign == "+" ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        } else {
            cell.amountLabel.isHidden = true
        }
        
        if let status = walletTransaction.destinationWithdrawalInfo?.status {
            var statusText = ""
            switch status {
            case .inProcess:
                statusText = "In process"
            default:
                statusText = status.rawValue
            }
            
            cell.statusLabel.text = statusText
        } else {
            cell.statusLabel.isHidden = true
        }
        
        if let information = walletTransaction.information {
            cell.titleLabel.text = information
        } else {
            cell.titleLabel.isHidden = true
        }
    
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        } else {
            cell.dateLabel.isHidden = true
        }
        
        cell.selectionStyle = .none
    }
}
