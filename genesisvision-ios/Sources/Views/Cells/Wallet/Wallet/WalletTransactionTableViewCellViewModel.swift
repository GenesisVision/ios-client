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
        
        if let action = walletTransaction.action, let sourceType = walletTransaction.sourceType, let destinationType = walletTransaction.destinationType, let value = walletTransaction.amount {
            var sign = ""
            
            switch action {
            case .transfer:
                if sourceType == .paymentTransaction, action == .transfer, destinationType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_profit")
                    sign = "+"
                }
                
                if sourceType == .wallet, action == .transfer, destinationType == .withdrawalRequest {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_loss")
                    sign = "-"
                }
                
                if sourceType == .withdrawalRequest, action == .transfer, destinationType == .paymentTransaction {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_loss")
                    sign = "-"
                }
            default:
                if sourceType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_loss")
                    sign = "-"
                } else if destinationType == .wallet {
                    cell.typeImageView.image = #imageLiteral(resourceName: "img_event_profit")
                    sign = "+"
                }
            }
            
            cell.amountLabel.text = sign + value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.amountLabel.text = ""
        }
        
        if let information = walletTransaction.information {
            cell.titleLabel.text = information
        } else {
            cell.titleLabel.text = ""
        }
    
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.selectionStyle = .none
    }
}
