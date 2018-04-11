//
//  ChartView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Charts

enum ChartType {
    case `default`, detail, full
}

class ChartView: CombinedChartView {

    // MARK: - Variables
    private var dataSet: [Chart]? = [] {
        didSet {
            updateData()
        }
    }
    
    private var name: String?
    
    private var chartType: ChartType = .default
    
    private var lineChartDataSet: LineChartDataSet! {
        didSet {
            lineChartDataSet.setColor(UIColor.primary)
            
            lineChartDataSet.lineWidth = 2
            
            lineChartDataSet.drawFilledEnabled = false
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawIconsEnabled = false
            
            lineChartDataSet.highlightEnabled = false
            
            lineChartDataSet.drawValuesEnabled = false
            lineChartDataSet.drawCircleHoleEnabled = false
            
            lineChartDataSet.mode = .cubicBezier
        }
    }
    
    private var fundDataSet: BarChartDataSet! {
        didSet {
            fundDataSet.setColor(UIColor.Font.blue)
            fundDataSet.drawValuesEnabled = false
            fundDataSet.highlightEnabled = false
        }
    }
    
    private var lossDataSet: BarChartDataSet! {
        didSet {
            fundDataSet.setColor(UIColor.Font.red)
            fundDataSet.drawValuesEnabled = false
            fundDataSet.highlightEnabled = false
        }
    }
    
    private var profitDataSet: BarChartDataSet! {
        didSet {
            fundDataSet.setColor(UIColor.Font.green)
            fundDataSet.drawValuesEnabled = false
            fundDataSet.highlightEnabled = false
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Public methods
    func setup(chartType: ChartType = .default, dataSet: [Chart]?, name: String? = "DataSet") {
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
    
    private func setFakeData(_ count: Int, range: UInt32) -> [Chart] {
        let values = (0..<count).map { (i) -> Chart in
            return Chart(date: nil, managerFund: nil, investorFund: nil, profit: nil, loss: nil, totalProfit: Double(arc4random_uniform(range) - range / 2))
        }
        
        return values
    }
    
    // MARK: - Private methods
    private func setup() {    
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
    }
    
    private func setData(_ values: [Chart]?) {
        guard let values = values, values.count > 0 else {
            return
        }
        
        let data = CombinedChartData()
        data.lineData = generateLineChart(values)
        
        if chartType == .full {
            data.barData = generateBarChart(values)
        }
        
        self.data = data
    }
    
    private func generateLineChart(_ values: [Chart]) -> LineChartData {
        let totalProfitDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: values[i].totalProfit ?? 0)
        }
        
        lineChartDataSet = LineChartDataSet(values: totalProfitDataEntry, label: "Total profit")
        
        return LineChartData(dataSet: lineChartDataSet)
    }
    
    private func generateBarChart(_ values: [Chart]) -> BarChartData {
        let fundDataEntry = (0..<values.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: values[i].investorFund ?? 0)
        }
        
        let lossDataEntry = (0..<values.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: values[i].loss ?? 0)
        }
        
        let profitDataEntry = (0..<values.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: values[i].profit ?? 0)
        }
        
        fundDataSet = BarChartDataSet(values: fundDataEntry, label: "Fund")
        lossDataSet = BarChartDataSet(values: lossDataEntry, label: "Loss")
        profitDataSet = BarChartDataSet(values: profitDataEntry, label: "Profit")
        
        return BarChartData(dataSets: [fundDataSet, lossDataSet, profitDataSet])
    }
}
