//
//  ProgramYourInvestmentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramYourInvestmentTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
    weak var programYourInvestmentProtocol: ProgramYourInvestmentProtocol?
}

extension ProgramYourInvestmentTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramYourInvestmentTableViewCell) {
        cell.withdrawButton.setEnabled(false)
        
        if let canWithdraw = programDetailsFull?.personalProgramDetails?.canWithdraw {
            cell.withdrawButton.setEnabled(canWithdraw)
        }
        
        cell.disclaimerLabel.text = "You can withdraw only the invested funds, the profit will be withdrawn to your account at the end of the period automatically."
        
        cell.programYourInvestmentProtocol = programYourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Your investment"
        cell.reinvestTitleLabel.text = "Auto reinvest"
        
        if let status = programDetailsFull?.personalProgramDetails?.status?.rawValue {
            cell.statusButton.setTitle(status, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        if let isReinvesting = programDetailsFull?.isReinvesting {
            cell.reinvestSwitch.isOn = isReinvesting
        }
        
        
        if let value = programDetailsFull?.personalProgramDetails?.value, let programCurrency = CurrencyType(rawValue: programDetailsFull?.currency?.rawValue ?? "") {
            cell.investedTitleLabel.text = "invested"
            cell.investedValueLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
            
            cell.valueTitleLabel.text = "value"
            cell.valueLabel.text = value.rounded(withType: programCurrency).toString() + " \(programCurrency.rawValue)"
        }
        
        if let profit = programDetailsFull?.personalProgramDetails?.profit {
            print(profit)
            cell.profitTitleLabel.text = "profit"
            cell.profitValueLabel.text = profit.rounded(toPlaces: 2).toString() + "%"
        }
        
    }
}
