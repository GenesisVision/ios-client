//
//  ChartView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Charts

class ChartView: LineChartView {

    // MARK: - Variables
    var dataSet: [Double] = [] {
        didSet {
            setData(dataSet)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartDescription?.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        legend.enabled = false
        drawGridBackgroundEnabled = false
        
        xAxis.enabled = false
        
        animate(xAxisDuration: 1.0)
    }
    
    // MARK: - Public methods
    func fakeData() {
        let values = setFakeData(50, range: 26)
        setData(values)
    }
    
    func updateData() {
        setData(dataSet)
    }
    
    private func setFakeData(_ count: Int, range: UInt32) -> [Double] {
        let values = (0..<count).map { (i) -> Double in
            return Double(arc4random_uniform(range)) - Double(range / 2)
        }
        
        return values
    }

    // MARK: - Private methods
    private func setData(_ values: [Double]) {
        let chartDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: values[i])
        }
        
        let chartDataSet = LineChartDataSet(values: chartDataEntry, label: "DataSet")
        
        chartDataSet.setColor(UIColor.primary)
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
