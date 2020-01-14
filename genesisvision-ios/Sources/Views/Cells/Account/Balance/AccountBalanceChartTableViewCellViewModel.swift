//
//  AccountBalanceChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 13/01/2020.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct AccountBalanceChartTableViewCellViewModel {
    let accountBalanceChart: AccountBalanceChart
    let currencyType: CurrencyType
    weak var chartViewProtocol: ChartViewProtocol?
}

extension AccountBalanceChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailBalanceChartTableViewCell) {
        cell.amountTitleLabel.text = "Amount"
        
        cell.chartViewProtocol = chartViewProtocol
        
        if let amountValue = accountBalanceChart.balance {
            cell.amountValueLabel.text = amountValue.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        } else {
            cell.amountValueLabel.isHidden = true
        }
        
        if let amountCurrency = accountBalanceChart.balance {
            cell.amountCurrencyLabel.text = amountCurrency.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        } else {
            cell.amountCurrencyLabel.isHidden = true
        }
        
        if let balanceChartData = accountBalanceChart.chart, balanceChartData.count > 0 {
            cell.chartViewHeightConstraint.constant = 200.0
            cell.chartView.setup(lineChartData: balanceChartData, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
        
        cell.managersFundsTitleLabel.text = "Manager funds"
        cell.investorsFundsTitleLabel.text = "Investors funds"
        cell.profitTitleLabel.text = "Profit"
        
        cell.chartModel = accountBalanceChart
    }
}
