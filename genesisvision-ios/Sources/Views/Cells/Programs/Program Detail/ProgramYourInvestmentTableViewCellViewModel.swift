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
        cell.titleLabel.text = "Current period invt."
        cell.reinvestTitleLabel.text = "Auto reinvest"
        
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
        
        if let invested = programDetailsFull?.personalProgramDetails?.invested, let profit = programDetailsFull?.personalProgramDetails?.profit {
            cell.investedTitleLabel.text = "invested"
            cell.investedValueLabel.text = invested.rounded(withType: currency).toString() + " " + currency.rawValue
            
            cell.profitTitleLabel.text = "profit"
            let profit = invested > 0 ? profit / invested * 100 : 0.0
            cell.profitValueLabel.text = profit.rounded(withType: .undefined).toString() + "%"
            cell.profitValueLabel.textColor = profit == 0 ? UIColor.Cell.title : profit > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        if let value = programDetailsFull?.personalProgramDetails?.value {
            cell.valueTitleLabel.text = "value"
            cell.valueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        }
    }
}
