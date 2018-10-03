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
        if let action = walletTransaction.action, let amount = walletTransaction.amount {
            var text: String?
            var textColor: UIColor?
            
            var arithmeticSign = ""
            
            cell.amountLabel.text = ""
            switch action {
            case .programInvest:
                text = "Invest To Program"
                textColor = UIColor.Font.red
                arithmeticSign = "-"
            case .programOpen:
                text = "Open Program"
                textColor = UIColor.Font.light
                arithmeticSign = ""
            case .programWithdrawal:
                text = "Withdraw From Program"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .programProfit:
                text = "Profit From Program"
                if amount == 0 {
                    textColor = UIColor.Font.medium
                    arithmeticSign = ""
                } else if amount > 0 {
                    textColor = UIColor.Font.primary
                    arithmeticSign = "+"
                } else {
                    textColor = UIColor.Font.red
                }
            case .programRequestCancel:
                text = "Cancel Investment Request"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .programRefundPartialExecution:
                text = "Partial Investment Execution Refund"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .programRequestInvest:
                text = "Program Request Invest"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .programRequestWithdrawal:
                text = "Program Request Withdrawal"
                textColor = UIColor.Font.red
                arithmeticSign = "-"
            case .programRefundClose:
                text = "Closing Program Refund"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            default:
                print(action)
                break
            }
            
//            cell.investTypeLabel.text = text
            cell.amountLabel.textColor = textColor
            cell.amountLabel.text = arithmeticSign + amount.rounded(withType: .gvt).toString()
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
//        if let title = walletTransaction.program?.title {
//            cell.programTitleLabel.text = title
//        } else {
//            cell.programTitleLabel.isHidden = true
//        }
        
//        if let status = walletTransaction.programRequest?.status {
//            cell.programStatusLabel.text = status.rawValue
//        } else {
//            cell.programStatusLabel.isHidden = true
//        }
        
        cell.selectionStyle = .none//walletTransaction.program != nil ? .default : .none
    }
}
