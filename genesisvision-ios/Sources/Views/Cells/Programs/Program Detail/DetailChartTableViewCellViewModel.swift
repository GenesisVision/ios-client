//
//  DetailChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct DetailChartTableViewCellViewModel {
    let chart: [Chart]
    let name: String
}


extension DetailChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailChartTableViewCell) {
        cell.noDataLabel.text = Constants.ErrorMessages.noDataText
        
        guard chart.count > 1 else {
            cell.chartView.isHidden = true
            cell.noDataLabel.isHidden = false
            return
        }
        
        cell.chartView.isHidden = false
        cell.noDataLabel.isHidden = true
        cell.chartView.setup(chartType: .default, dataSet: chart, name: name)
    }
}
