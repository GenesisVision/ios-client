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
            cell.amountValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " GVT"
        } else {
            cell.amountValueLabel.isHidden = true
        }
        
        if let amountCurrency = programProfitChart.totalProgramCurrencyProfit {
            cell.amountCurrencyLabel.text = amountCurrency.toString()
        } else {
            cell.amountCurrencyLabel.isHidden = true
        }
        
        
        cell.changeTitleLabel.text = "Change"
        
        if let changePercent = programProfitChart.profitChangePercent {
            cell.changePercentLabel.text = changePercent.toString()
        } else {
            cell.changePercentLabel.isHidden = true
        }
        
        if let changeValue = programProfitChart.totalGvtProfit {
            cell.changeValueLabel.text = changeValue.rounded(withType: .gvt).toString() + " GVT"
        } else {
            cell.changeValueLabel.isHidden = true
        }
        
        if let changeCurrency = programProfitChart.totalProgramCurrencyProfit {
            let selectedCurrency = getSelectedCurrency()
            if let currencyType = CurrencyType(rawValue: selectedCurrency) {
                cell.changeCurrencyLabel.text = changeCurrency.rounded(withType: currencyType).toString() + " " + selectedCurrency
            }
        } else {
            cell.changeCurrencyLabel.isHidden = true
        }
        
        if let equityChart = programProfitChart.equityChart {
            cell.chartView.setup(chartType: .default, lineChartData: equityChart)
        } else {
            cell.chartView.isHidden = true
        }
    }
}
