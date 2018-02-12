//
//  DetailChartTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct DetailChartTableViewCellViewModel {
    let chart: [Double]
}


extension DetailChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailChartTableViewCell) {
        cell.chartView.dataSet = chart
    }
}
