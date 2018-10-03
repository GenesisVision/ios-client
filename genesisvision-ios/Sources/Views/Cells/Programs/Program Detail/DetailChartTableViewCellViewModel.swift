//
//  DetailChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct DetailChartTableViewCellViewModel {
    let chart: [ChartSimple]
    let name: String
    let currencyValue: String?
    let chartDurationType: ChartDurationType?
    weak var detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?
}


extension DetailChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailChartTableViewCell) {
        cell.noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        guard chart.count > 1 else {
            cell.chartView.isHidden = true
            cell.noDataLabel.isHidden = false
            return
        }
        
        cell.chartView.isHidden = false
        cell.noDataLabel.isHidden = true
        if let first = chart.first?.value, let last = chart.last?.value {
            let value = last - first
            let upDownSign = value == 0 ? "" : value > 0 ? "↑ " : "↓ "
            
            var text = upDownSign + value.rounded(withType: .gvt).toString()
            text += value > 0 ? " %" : ""
//            let percent = first == 0 ? 0 : abs(100 / first * (first - last))
//            text += percent > 0 ? " (" + percent.rounded(toPlaces: 0).toString() + " %)" : ""
            
            cell.changesLabel.text = text
            cell.changesLabel.textColor = value == 0 ? UIColor.Font.darkBlue : value > 0 ? UIColor.Font.green : UIColor.Font.red
        }
        cell.chartView.setup(chartType: .detail, lineChartData: chart, name: name, currencyValue: currencyValue, chartDurationType: chartDurationType)
        cell.delegate = detailChartTableViewCellProtocol
    }
}
