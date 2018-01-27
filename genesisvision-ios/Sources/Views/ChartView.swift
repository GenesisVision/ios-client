//
//  ChartView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Charts

class ChartView: LineChartView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartDescription?.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        legend.enabled = false
        drawGridBackgroundEnabled = false
        
        xAxis.enabled = false
        
        animate(xAxisDuration: 1.0)
        
        fakeData()
    }
    
    // MARK: - Public methods
    func fakeData() {
        setDataCount(50, range: 26)
    }

    // MARK: - Private methods
    private func setDataCount(_ count: Int, range: UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range)) - Double(range / 2)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let chartDataSet = LineChartDataSet(values: values, label: "DataSet")
        
        chartDataSet.setColor(UIColor(.blue))
        chartDataSet.lineWidth = 1
        
        chartDataSet.drawFilledEnabled = false
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawIconsEnabled = false
        chartDataSet.highlightEnabled = false
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCircleHoleEnabled = false
        
        chartDataSet.mode = .cubicBezier
        
        let chartData = LineChartData(dataSet: chartDataSet)
        
        data = chartData
    }
}
