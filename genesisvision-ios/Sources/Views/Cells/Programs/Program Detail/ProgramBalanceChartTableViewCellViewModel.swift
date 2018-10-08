//
//  ProgramBalanceChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramBalanceChartTableViewCellViewModel {
    let programBalanceChart: ProgramBalanceChart
}

extension ProgramBalanceChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramBalanceChartTableViewCell) {
        cell.amountTitleLabel.text = "Amount"
        
        if let amountValue = programBalanceChart.gvtBalance {
            cell.amountValueLabel.text = amountValue.toString()
        }
        
        if let amountCurrency = programBalanceChart.programCurrencyBalance {
            cell.amountCurrencyLabel.text = amountCurrency.toString()
        }
        
        
        cell.changeTitleLabel.isHidden = true
        cell.changePercentLabel.isHidden = true
        cell.changeValueLabel.isHidden = true
        cell.changeCurrencyLabel.isHidden = true
    }
}
