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
    func setup(on cell: DetailProfitChartTableViewCell) {
        
        cell.chartViewProtocol = chartViewProtocol
        
        cell.amountTitleLabel.text = "Amount"
        
        if let amountValue = programProfitChart.totalGvtProfit {
            cell.amountValueLabel.text = amountValue.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.amountValueLabel.isHidden = true
        }
        
        if let amountCurrency = programProfitChart.totalProgramCurrencyProfit, let programCurrency = programProfitChart.programCurrency, let currencyType = CurrencyType(rawValue: programCurrency.rawValue) {
            cell.amountCurrencyLabel.text = amountCurrency.rounded(with: currencyType).toString() + " " + currencyType.rawValue
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
            cell.changeValueLabel.text = changeValue.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.changeValueLabel.isHidden = true
        }
        
        if let changeCurrency = programProfitChart.timeframeProgramCurrencyProfit, let programCurrency = programProfitChart.programCurrency, let currencyType = CurrencyType(rawValue: programCurrency.rawValue) {
            cell.changeCurrencyLabel.text = changeCurrency.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        } else {
            cell.changeCurrencyLabel.isHidden = true
        }
        
        if let equityChart = programProfitChart.equityChart, equityChart.count > 0 {
            cell.chartViewHeightConstraint.constant = 150.0
            cell.chartView.setup(lineChartData: equityChart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
    }
}
