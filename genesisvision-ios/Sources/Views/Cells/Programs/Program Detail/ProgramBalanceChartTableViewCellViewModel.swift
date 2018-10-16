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
            cell.amountValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.amountValueLabel.isHidden = true
        }
        
        if let amountCurrency = programBalanceChart.programCurrencyBalance {
            let selectedCurrency = getSelectedCurrency()
            if let currencyType = CurrencyType(rawValue: selectedCurrency) {
                cell.amountCurrencyLabel.text = amountCurrency.rounded(withType: currencyType).toString() + " " + selectedCurrency
            }
        } else {
            cell.amountCurrencyLabel.isHidden = true
        }
        
        cell.changeTitleLabel.isHidden = true
        cell.changePercentLabel.isHidden = true
        cell.changeValueLabel.isHidden = true
        cell.changeCurrencyLabel.isHidden = true
        
        if let balanceChartData = programBalanceChart.balanceChart, balanceChartData.count > 0 {
            cell.chartViewHeightConstraint.constant = 150.0
            cell.chartView.setup(balanceChartData: balanceChartData)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
    }
}
