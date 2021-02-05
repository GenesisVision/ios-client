//
//  ProgramProfitChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramProfitChartTableViewCellViewModel {
    let programProfitChart: ProgramProfitPercentCharts?
    let followProfitChart: AbsoluteProfitChart?
    weak var chartViewProtocol: ChartViewProtocol?
}

extension ProgramProfitChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitChartTableViewCell) {
        
        if programProfitChart != nil {
            cell.chartViewProtocol = chartViewProtocol
            
            cell.amountTitleLabel.text = "Amount"
            
            cell.amountValueLabel.isHidden = true
        
            cell.amountCurrencyLabel.isHidden = true
        
            cell.changePercentLabel.isHidden = true
        
            cell.changeValueLabel.isHidden = true
        
            cell.changeCurrencyLabel.isHidden = true
            
            if let charts = programProfitChart?.charts, let equityChart = charts[0].chart, equityChart.count > 0 {
                let chart = equityChart.map { (point) -> SimpleChartPoint? in
                    guard point.date != nil else { return nil }
                    return SimpleChartPoint(date: Int64(Double(point.date!)*0.001), value: point.value)
                }.compactMap{ $0 }
                cell.chartViewHeightConstraint.constant = 150.0
                cell.chartView.setup(lineChartData: chart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
                cell.chartView.isHidden = false
            } else {
                cell.chartViewHeightConstraint.constant = 0.0
                cell.chartView.isHidden = true
            }
            
        } else if followProfitChart != nil {
            cell.chartViewProtocol = chartViewProtocol
            
            cell.amountTitleLabel.text = "Amount"
            
            cell.amountValueLabel.isHidden = true
        
            cell.amountCurrencyLabel.isHidden = true
        
            cell.changePercentLabel.isHidden = true
        
            cell.changeValueLabel.isHidden = true
        
            cell.changeCurrencyLabel.isHidden = true
            
            if let chartRaw = followProfitChart?.chart {
                let chart = chartRaw.map { (point) -> SimpleChartPoint? in
                    guard point.date != nil else { return nil }
                    return SimpleChartPoint(date: Int64(Double(point.date!)*0.001), value: point.value)
                }.compactMap{ $0 }
                cell.chartViewHeightConstraint.constant = 150.0
                cell.chartView.setup(lineChartData: chart, dateRangeModel: chartViewProtocol?.filterDateRangeModel)
                cell.chartView.isHidden = false
            } else {
                cell.chartViewHeightConstraint.constant = 0.0
                cell.chartView.isHidden = true
            }
        }
    }
}
