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
        if let type = walletTransaction.type, let amount = walletTransaction.amount {
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
                textColor = amount == 0 ? UIColor.Font.medium : (amount > 0 ? UIColor.Font.green : UIColor.Font.red)
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
            case .closingProgramRefund:
                text = "Closing Program Refund"
                textColor = UIColor.Font.medium
            }
            
            cell.investTypeLabel.text = text
            cell.amountLabel.textColor = textColor
            cell.amountLabel.text = String(describing: amount.rounded(toPlaces: 4))
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
        cell.currencyLabel.text = Constants.currency
    }
}
