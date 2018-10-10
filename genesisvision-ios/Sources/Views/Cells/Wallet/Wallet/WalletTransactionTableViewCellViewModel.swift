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
        if let type = walletTransaction.sourceType {
            cell.titleLabel.text = type.rawValue.capitalized
        }
        
        if let action = walletTransaction.action {
            switch action {
            case .programInvest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
            case .programProfit:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .programWithdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .programRequestWithdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .programRequestInvest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
            default:
                cell.typeImageView.image = nil
            }
        }
    
        if let value = walletTransaction.amount {
            let sign = value > 0 ? "+" : value < 0 ? "-" : ""
            cell.amountLabel.text = sign + value.rounded(withType: .gvt).toString() + " GVT"
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
        cell.selectionStyle = .none
    }
}
