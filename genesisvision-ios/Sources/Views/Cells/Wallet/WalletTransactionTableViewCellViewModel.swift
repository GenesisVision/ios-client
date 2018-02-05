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
        if let type = walletTransaction.type {
            cell.investTypeLabel.text = type.rawValue
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
        if let amount = walletTransaction.amount {
            cell.amountLabel.textColor = amount >= 0 ? UIColor.Transaction.greenTransaction : UIColor.Transaction.redTransaction
            cell.amountLabel.text = String(describing: amount)
        }
        
        cell.currencyLabel.text = Constants.currency
    }
}
