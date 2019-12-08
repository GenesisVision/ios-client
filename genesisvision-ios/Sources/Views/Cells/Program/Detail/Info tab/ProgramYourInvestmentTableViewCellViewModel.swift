//
//  YourInvestmentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct ProgramYourInvestmentTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
    weak var yourInvestmentProtocol: YourInvestmentProtocol?
}

extension ProgramYourInvestmentTableViewCellViewModel: CellViewModel {
    func setup(on cell: YourInvestmentTableViewCell) {
        cell.withdrawButton.setEnabled(false)
        
        if let canWithdraw = programDetailsFull?.personalProgramDetails?.canWithdraw {
            cell.withdrawButton.setEnabled(canWithdraw)
        }
        
        cell.disclaimerLabel.text = "You can withdraw only the invested funds, the profit will be withdrawn to your account at the end of the period automatically."

        cell.yourInvestmentProtocol = yourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Current period investment"
        cell.reinvestTitleLabel.text = "Reinvest profit"
        
        if let status = programDetailsFull?.personalProgramDetails?.status?.rawValue {
            cell.statusButton.setTitle(status, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        if let isReinvesting = programDetailsFull?.personalProgramDetails?.isReinvest {
            cell.reinvestSwitch.isOn = isReinvesting
        }
        
        let currency = CurrencyType(rawValue: programDetailsFull?.currency?.rawValue ?? "") ?? .usd
        
        cell.investedTitleLabel.isHidden = true
        cell.investedValueLabel.isHidden = true
        
        cell.profitTitleLabel.text = "profit"
        if let profitPercent = programDetailsFull?.personalProgramDetails?.profit,
            let value = programDetailsFull?.personalProgramDetails?.value,
            let invested = programDetailsFull?.personalProgramDetails?.invested {
            let profitValue = value - invested
            let sign = profitValue > 0 ? "+" : ""
            cell.profitValueLabel.text = sign + profitValue.rounded(with: currency).toString() + " " + currency.rawValue + " (\(profitPercent.rounded(with: .undefined).toString())%)"
            cell.profitValueLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        cell.valueTitleLabel.text = "value"
        if let value = programDetailsFull?.personalProgramDetails?.value {
            cell.valueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        }
    }
}
