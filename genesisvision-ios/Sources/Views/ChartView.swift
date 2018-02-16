//
//  ChartView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Charts

enum ChartType {
    case `default`, detail
}

class ChartView: LineChartView {

    // MARK: - Variables
    private var dataSet: [Double]? = [] {
        didSet {
            updateData()
        }
    }
    
    private var name: String?
    
    private var chartType: ChartType = .default
    
    private var chartDataSet: LineChartDataSet! {
        didSet {
            dragEnabled = chartType == .detail
            pinchZoomEnabled = chartType == .detail
            
            rightAxis.enabled = chartType == .detail
            rightAxis.drawGridLinesEnabled = true
            rightAxis.gridColor = UIColor.Font.light
            rightAxis.axisLineColor = UIColor.Font.medium
            rightAxis.labelTextColor = UIColor.Font.dark
            
            chartDescription?.enabled = false
            leftAxis.enabled = false
            legend.enabled = false
            drawGridBackgroundEnabled = false
            autoScaleMinMaxEnabled = true
            
            xAxis.enabled = false
            
            chartDataSet.setColor(UIColor.primary)
            chartDataSet.fillColor = UIColor.primary
            
            chartDataSet.lineWidth = 1
            
            chartDataSet.drawFilledEnabled = true
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.drawIconsEnabled = false
            
            chartDataSet.highlightEnabled = false
            
            chartDataSet.drawValuesEnabled = false
            chartDataSet.drawCircleHoleEnabled = false
            
            chartDataSet.mode = .cubicBezier
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Public methods
    func setup(chartType: ChartType = .default, dataSet: [Double]?, name: String? = "DataSet") {
        self.chartType = chartType
        self.name = name
        self.dataSet = dataSet
    }
    
    func fakeData() {
        dataSet = setFakeData(50, range: 26)
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
    private func setup() {
        backgroundColor = UIColor.Background.main
        
        animate(xAxisDuration: 1.0)
    }
    
    private func setData(_ values: [Double]?) {
        guard let values = values, values.count > 0 else {
            return
        }
        
        let chartDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: values[i])
        }
        
        chartDataSet = LineChartDataSet(values: chartDataEntry, label: name ?? "")
        data = LineChartData(dataSet: chartDataSet)
    }
}
