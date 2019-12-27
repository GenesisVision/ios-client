//
//  ProgramProfitChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramProfitChartTableViewCellViewModel {
    let programProfitChart: ProgramProfitPercentCharts
    weak var chartViewProtocol: ChartViewProtocol?
}

extension ProgramProfitChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitChartTableViewCell) {
        
        cell.chartViewProtocol = chartViewProtocol
        
        cell.amountTitleLabel.text = "Amount"
        
        cell.amountValueLabel.isHidden = true
    
        cell.amountCurrencyLabel.isHidden = true
    
        cell.changePercentLabel.isHidden = true
    
        cell.changeValueLabel.isHidden = true
    
        cell.changeCurrencyLabel.isHidden = true
        
        if let charts = programProfitChart.charts, let equityChart = charts[0].chart, equityChart.count > 0 {
            cell.chartViewHeightConstraint.constant = 150.0
            cell.chartView.setup(lineChartData: equityChart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
            cell.chartView.isHidden = false
        } else {
            cell.chartViewHeightConstraint.constant = 0.0
            cell.chartView.isHidden = true
        }
    }
}
