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
        
        if let amountValue = fundBalanceChart.balance {
            cell.amountValueLabel.text = amountValue.rounded(with: getPlatformCurrencyType()).toString() + " \(getPlatformCurrencyType().rawValue)"
        } else {
            cell.amountValueLabel.isHidden = true
        }

        cell.amountCurrencyLabel.isHidden = true
        
        if let balanceChartData = fundBalanceChart.chart, balanceChartData.count > 0 {
            cell.chartViewHeightConstraint.constant = 200.0
            let chart = balanceChartData.map { (point) -> BalanceChartPoint? in
                guard point.date != nil else { return nil }
                return BalanceChartPoint(date: Int64(Double(point.date!)*0.001), managerFunds: point.managerFunds, investorsFunds: point.investorsFunds)
            }.compactMap{ $0 }
            cell.chartView.setup(fundBalanceChartData: chart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
        
        cell.managersFundsTitleLabel.text = "Manager funds"
        cell.managersFundsTitleLabel.sizeToFit()
        cell.investorsFundsTitleLabel.text = "Investors funds"
        cell.investorsFundsTitleLabel.sizeToFit()
        
        cell.chartModel = fundBalanceChart
    }
}
