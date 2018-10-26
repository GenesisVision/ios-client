//
//  FundBalanceChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundBalanceChartTableViewCellViewModel {
    let fundBalanceChart: FundBalanceChart
    weak var chartViewProtocol: ChartViewProtocol?
}

extension FundBalanceChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailBalanceChartTableViewCell) {
        cell.amountTitleLabel.text = "Amount"
        
        cell.chartViewProtocol = chartViewProtocol
        
        if let amountValue = fundBalanceChart.gvtBalance {
            cell.amountValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.amountValueLabel.isHidden = true
        }
        
        if let amountCurrency = fundBalanceChart.usdBalance {
            let currencyType: CurrencyType = .usd
            cell.amountCurrencyLabel.text = amountCurrency.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        } else {
            cell.amountCurrencyLabel.isHidden = true
        }
        
        cell.changeTitleLabel.isHidden = true
        cell.changePercentLabel.isHidden = true
        cell.changeValueLabel.isHidden = true
        cell.changeCurrencyLabel.isHidden = true
        
        if let balanceChartData = fundBalanceChart.balanceChart, balanceChartData.count > 0 {
            cell.chartViewHeightConstraint.constant = 300.0
            cell.chartView.setup(fundBalanceChartData: balanceChartData)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
    }
}
