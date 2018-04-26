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
    let chart: [TradeChart]
    let name: String
    let currencyValue: String?
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
        if let first = chart.first?.profit, let last = chart.last?.profit {
            let value = last - first
            let percent = first == 0 ? last * 100 : (value == 0 ? 0 : value > 0 ? (last - first / first * 100) : (first - last / first * 100))
            let upDownSign = value == 0 ? "" : value > 0 ? "↑ " : "↓ "
            
            let text = upDownSign + value.rounded(withType: .gvt).toString() + " % (" + percent.rounded(toPlaces: 0).toString() + " %)"
            
            cell.changesLabel.text = text
            cell.changesLabel.textColor = value == 0 ? UIColor.Font.darkBlue : value > 0 ? UIColor.Font.green : UIColor.Font.red
        }
        cell.chartView.setup(chartType: .detail, tradeChartDataSet: chart, name: name, currencyValue: currencyValue)
        cell.delegate = detailChartTableViewCellProtocol
    }
}
