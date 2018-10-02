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
            
            var arithmeticSign = ""
            
            cell.amountLabel.text = ""
            switch type {
            case .investToProgram:
                text = "Invest To Program"
                textColor = UIColor.Font.red
                arithmeticSign = "-"
            case .openProgram:
                text = "Open Program"
                textColor = UIColor.Font.light
                arithmeticSign = ""
            case .withdrawFromProgram:
                text = "Withdraw From Program"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .profitFromProgram:
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
            case .cancelInvestmentRequest:
                text = "Cancel Investment Request"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .partialInvestmentExecutionRefund:
                text = "Partial Investment Execution Refund"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .deposit:
                text = "Deposit"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            case .withdraw:
                text = "Withdraw"
                textColor = UIColor.Font.red
                arithmeticSign = "-"
            case .closingProgramRefund:
                text = "Closing Program Refund"
                textColor = UIColor.Font.primary
                arithmeticSign = "+"
            }
            
//            cell.investTypeLabel.text = text
            cell.amountLabel.textColor = textColor
            cell.amountLabel.text = arithmeticSign + amount.rounded(withType: .gvt).toString()
        }
        
        if let date = walletTransaction.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        
        if let title = walletTransaction.investmentProgram?.title {
            cell.programTitleLabel.text = title
        } else {
            cell.programTitleLabel.isHidden = true
        }
        
//        if let status = walletTransaction.investmentProgramRequest?.status {
//            cell.programStatusLabel.text = status.rawValue
//        } else {
//            cell.programStatusLabel.isHidden = true
//        }
        
        cell.selectionStyle = walletTransaction.investmentProgram != nil ? .default : .none
    }
}
