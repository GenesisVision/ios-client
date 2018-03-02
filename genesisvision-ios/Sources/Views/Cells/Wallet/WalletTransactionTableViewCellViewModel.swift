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
            var text: String?
            var textColor: UIColor?
            
            switch type {
            case .investToProgram:
                text = "Invest To Program"
                textColor = UIColor.Font.red
            case .openProgram:
                text = "Open Program"
                textColor = UIColor.Font.light
            case .withdrawFromProgram:
                text = "Withdraw From Program"
                textColor = UIColor.Font.green
            case .profitFromProgram:
                text = "Profit From Program"
                textColor = UIColor.Font.green
            case .cancelInvestmentRequest:
                text = "Cancel Investment Request"
                textColor = UIColor.Font.green
            case .partialInvestmentExecutionRefund:
                text = "Partial Investment Execution Refund"
                textColor = UIColor.Font.medium
            case .deposit:
                text = "Deposit"
                textColor = UIColor.Font.green
            case .withdraw:
                text = "Withdraw"
                textColor = UIColor.Font.red
            }
            
            cell.investTypeLabel.text = text
            cell.amountLabel.textColor = textColor
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
        if let amount = walletTransaction.amount {
            cell.amountLabel.text = String(describing: amount)
        }
        
        cell.currencyLabel.text = Constants.currency
    }
}
