//
//  ProgramProfitChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramProfitChartTableViewCellViewModel {
    let programProfitChart: ProgramProfitChart
}

extension ProgramProfitChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramProfitChartTableViewCell) {
        
        cell.amountTitleLabel.text = "Amount"
        
        if let amountValue = programProfitChart.balance {
            cell.amountValueLabel.text = amountValue.toString()
        }
        
        if let amountCurrency = programProfitChart.totalProgramCurrencyProfit {
            cell.amountCurrencyLabel.text = amountCurrency.toString()
        }
        
        
        cell.changeTitleLabel.text = "Change"
        
        if let changePercent = programProfitChart.profitChangePercent {
            cell.changePercentLabel.text = changePercent.toString()
        }
        
        if let changeValue = programProfitChart.totalGvtProfit {
            cell.changeValueLabel.text = changeValue.toString()
        }
        
        if let changeCurrency = programProfitChart.totalProgramCurrencyProfit {
            cell.changeCurrencyLabel.text = changeCurrency.toString()
        }
        
    }
}
