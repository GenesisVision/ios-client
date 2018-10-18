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
    weak var chartViewProtocol: ChartViewProtocol?
}

extension ProgramProfitChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramProfitChartTableViewCell) {
        
        cell.chartViewProtocol = chartViewProtocol
        
        cell.amountTitleLabel.text = "Amount"
        
        if let amountValue = programProfitChart.totalGvtProfit {
            cell.amountValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
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
        
        if let changeValue = programProfitChart.timeframeGvtProfit {
            cell.changeValueLabel.text = changeValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.changeValueLabel.isHidden = true
        }
        
        if let changeCurrency = programProfitChart.timeframeProgramCurrencyProfit {
            let selectedCurrency = getSelectedCurrency()
            if let currencyType = CurrencyType(rawValue: selectedCurrency) {
                cell.changeCurrencyLabel.text = changeCurrency.rounded(withType: currencyType).toString() + " " + selectedCurrency
            }
        } else {
            cell.changeCurrencyLabel.isHidden = true
        }
        
        if let equityChart = programProfitChart.equityChart, equityChart.count > 0 {
            cell.chartViewHeightConstraint.constant = 150.0
            cell.chartView.setup(lineChartData: equityChart)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
    }
}
