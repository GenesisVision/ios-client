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
            var text = ""
            
            switch type {
            case .investToProgram:
                text = "Invest To Program"
            case .openProgram:
                text = "Open Program"
            case .withdrawFromProgram:
                text = "Withdraw From Program"
            case .profitFromProgram:
                text = "Profit From Program"
            case .cancelInvestmentRequest:
                text = "Cancel Investment Request"
            case .partialInvestmentExecutionRefund:
                text = "Partial Investment Execution Refund"
            default:
                text = type.rawValue
            }
            
            cell.investTypeLabel.text = text
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
