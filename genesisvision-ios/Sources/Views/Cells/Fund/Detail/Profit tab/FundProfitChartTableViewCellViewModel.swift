//
//  FundProfitChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundProfitChartTableViewCellViewModel {
    let fundProfitChart: FundProfitChart
    weak var chartViewProtocol: ChartViewProtocol?
}

extension FundProfitChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitChartTableViewCell) {
        
        cell.chartViewProtocol = chartViewProtocol
        
        cell.amountTitleLabel.text = "Value"
        
        cell.amountCurrencyLabel.isHidden = true
        
        if let equityChart = fundProfitChart.equityChart, equityChart.count > 0 {
            if let value = equityChart.last?.value {
                cell.amountValueLabel.text = value.rounded(withType: .undefined).toString() + "%"
            } else {
                cell.amountValueLabel.isHidden = true
            }
            
            cell.chartViewHeightConstraint.constant = 150.0
            cell.chartView.setup(lineChartData: equityChart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
            cell.chartView.isHidden = false
            
            cell.changeTitleLabel.text = "Change"
            if let firstValue = equityChart.first?.value, let lastValue = equityChart.last?.value {
                cell.changePercentLabel.text = getChangePercent(oldValue: firstValue, newValue: lastValue)
            }
            
            if let changeValue = fundProfitChart.timeframeGvtProfit {
                cell.changeValueLabel.text = changeValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
            } else {
                cell.changeValueLabel.isHidden = true
            }
            
            if let changeCurrency = fundProfitChart.timeframeUsdProfit {
                let currencyType: CurrencyType = .usd
                
                cell.changeCurrencyLabel.text = changeCurrency.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            } else {
                cell.changeCurrencyLabel.isHidden = true
            }
            
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
            
            cell.changeTitleLabel.isHidden = true
            cell.changePercentLabel.isHidden = true
            cell.changeValueLabel.isHidden = true
            cell.changeCurrencyLabel.isHidden = true
        }
    }
}
