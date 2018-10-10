//
//  ProgramYourInvestmentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramYourInvestmentTableViewCellViewModel {
    let value: Double?
    let profit: Double?
    let invested: Double?
    let isReinvesting: Bool?
    let programCurrency: CurrencyType?
    
    weak var programYourInvestmentProtocol: ProgramYourInvestmentProtocol?
}

extension ProgramYourInvestmentTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramYourInvestmentTableViewCell) {
        cell.programYourInvestmentProtocol = programYourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Your investment"
        cell.reinvestTitleLabel.text = "Auto reinvest"
        if let isReinvesting = isReinvesting {
            cell.reinvestSwitch.isOn = isReinvesting
        }
        
        if let value = value, let programCurrency = programCurrency {
            cell.valueTitleLabel.text = "value"
            cell.valueLabel.text = value.rounded(withType: programCurrency).toString() + " \(programCurrency.rawValue)"
        }
        
        if let invested = invested {
            cell.investedTitleLabel.text = "invested"
            cell.investedValueLabel.text = invested.rounded(withType: .gvt).toString() + " GVT"
        }
        
        if let profit = profit {
            cell.profitTitleLabel.text = "profit"
            cell.profitValueLabel.text = profit.rounded(toPlaces: 2).toString() + "%"
        }
        
    }
}
