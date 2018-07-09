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

enum ChartDurationType: Int {
    case day, week, month, month3, month6, year, all
    
    var allCases: [String] {
        return ["1d", "1w", "1m", "3m", "6m", "1y", "all"]
    }
    
    func getTimeFrame() -> InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet {
        var timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.day1
        
        switch self {
        case .day:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.day1
        case .week:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.week1
        case .month:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.month1
        case .month3:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.month3
        case .month6:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.month6
        case .year:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.year1
        case .all:
            timeFrame = InvestorAPI.TimeFrame_apiInvestorInvestmentProgramEquityChartGet.all
        }
        
        return timeFrame
    }
}

protocol ChartViewProtocol: class {
    func didHideMarker()
    func didChangeMarker()
}

class ChartView: CombinedChartView {

    // MARK: - Variables
    weak var chartViewProtocol: ChartViewProtocol?
    
    private var tradeChartDataSet: [TradeChart]? {
        didSet {
            updateData()
        }
    }
    
    private var chartDataSet: [Chart]? {
        didSet {
            updateData()
        }
    }
    
    private var chartByDateDataSet: [ChartByDate]? {
        didSet {
            updateData()
        }
    }
    
    private var name: String?
    private var currencyValue: String = ""
    
    private var chartType: ChartType = .default
    private var chartDurationType: ChartDurationType!
    
    private var lineChartDataSet: LineChartDataSet! {
        didSet {
            lineChartDataSet.setColor(UIColor.primary)
            lineChartDataSet.lineWidth = 1.5
            
            lineChartDataSet.drawFilledEnabled = chartType != .default
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawIconsEnabled = false
            
            lineChartDataSet.highlightEnabled = true
            lineChartDataSet.highlightColor = UIColor.Font.dark
            lineChartDataSet.setDrawHighlightIndicators(true)
            lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true
            
            let gradientColors = [UIColor.primary.withAlphaComponent(0.0).cgColor, UIColor.primary.cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            lineChartDataSet.fillAlpha = 0.7
            lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
            
            lineChartDataSet.drawValuesEnabled = false
            lineChartDataSet.drawCircleHoleEnabled = false
            
            lineChartDataSet.mode = .horizontalBezier
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
        
        backgroundColor = .clear
    }
    
    // MARK: - Public methods
    func setup(chartType: ChartType = .default, chartDataSet: [Chart]? = nil, tradeChartDataSet: [TradeChart]? = nil, chartByDateDataSet: [ChartByDate]? = nil, name: String? = "DataSet", currencyValue: String? = nil, chartDurationType: ChartDurationType? = nil) {
        self.chartType = chartType
        self.name = name
        self.chartDataSet = chartDataSet
        self.tradeChartDataSet = tradeChartDataSet
        self.chartByDateDataSet = chartByDateDataSet
        self.currencyValue = currencyValue ?? ""
        self.chartDurationType = chartDurationType ?? .all
        
        setup()
    }
    
    func fakeData() {
        tradeChartDataSet = setFakeData(50, range: 26)
    }
    
    func updateData() {
        if tradeChartDataSet != nil {
            setData(tradeChartDataSet)
        } else if chartByDateDataSet != nil {
            setData(chartByDateDataSet)
        } else {
            setData(chartDataSet)
        }
    }
    
    private func setFakeData(_ count: Int, range: UInt32) -> [TradeChart] {
        let values = (0..<count).map { (i) -> TradeChart in
            return TradeChart(date: nil, profit: Double(arc4random_uniform(range) - range / 2))
        }
        
        return values
    }
    
    // MARK: - Private methods
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .ended, .cancelled:
            highlightValue(nil, callDelegate: false)
            chartViewProtocol?.didHideMarker()
        case .changed:
            chartViewProtocol?.didChangeMarker()
            break
        default:
            break
        }
    }
    
    private func setup() {
        if let gestureRecognizers = gestureRecognizers {
            for recognizer in gestureRecognizers {
                if recognizer is UIPanGestureRecognizer {
                    recognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
                }
            }
        }
        
        if chartType == .default, let firstValue = chartByDateDataSet?.first?.value, let lastValue = chartByDateDataSet?.last?.value {
            
            lineChartDataSet.setColor(firstValue > lastValue ? UIColor.Font.red : UIColor.primary)
        }
        
        scaleXEnabled = chartType == .full
        scaleYEnabled = chartType == .full
        doubleTapToZoomEnabled = chartType == .full
        dragEnabled = chartType != .default
        pinchZoomEnabled = chartType == .full

        highlightPerTapEnabled = chartType == .full
        highlightPerDragEnabled = chartType != .default
       
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.minimumFractionDigits = 0
        rightAxisFormatter.maximumFractionDigits = 1
        rightAxisFormatter.negativeSuffix = " " + currencyValue
        rightAxisFormatter.positiveSuffix = " " + currencyValue
        
        //leftAxis
        leftAxis.enabled = false
        leftAxis.drawGridLinesEnabled = false
        
        //rightAxis
        rightAxis.enabled = true
        rightAxis.labelTextColor = UIColor.Font.dark
        
        //grid
        rightAxis.drawGridLinesEnabled = false
        rightAxis.gridColor = UIColor.Font.light
        rightAxis.gridLineDashLengths = [3.0, 3.0]
        rightAxis.gridLineWidth = 1.0

        //axis
        rightAxis.drawLabelsEnabled = chartType == .full
        rightAxis.drawAxisLineEnabled = chartType == .full
        rightAxis.axisLineWidth = 2.0
        rightAxis.axisLineColor = UIColor.Font.dark
        rightAxis.labelFont = UIFont.getFont(.light, size: 13)
        
        //yZeroLine
        rightAxis.drawZeroLineEnabled = true
        rightAxis.zeroLineColor = UIColor.Cell.separator
        rightAxis.zeroLineWidth = 1.0
        rightAxis.zeroLineDashLengths = chartType == .default ? [2.0, 2.0] : [2.0, 6.0]
        
        drawGridBackgroundEnabled = false
        
        //xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.labelRotationAngle = 0.3
        xAxis.labelFont = UIFont.getFont(.light, size: 13)
        xAxis.labelTextColor = UIColor.Font.dark
        xAxis.axisLineWidth = 2.0
        xAxis.axisLineColor = UIColor.Font.dark
        xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let date = Date(timeIntervalSince1970: index)
            let dateString = Date.getFormatStringForChart(for: date, chartDurationType: self.chartDurationType)
            return dateString
        })
        
        xAxis.labelPosition = .bottom
        xAxis.enabled = chartType == .full
        
        chartDescription?.enabled = false
        
        legend.enabled = false
        autoScaleMinMaxEnabled = true
        
        if chartType != .default {
            animate(xAxisDuration: 0.5)
        }
    }
    
    private func setData(_ values: [TradeChart]?) {
        guard let values = values, values.count > 0 else {
            return
        }
        
        let data = CombinedChartData()
        data.lineData = generateLineChart(values)

        self.data = data
    }
    
    private func setData(_ values: [Chart]?) {
        guard let values = values, values.count > 0 else {
            return
        }
        
        let data = CombinedChartData()
        data.lineData = generateLineChart(values)

        self.data = data
    }
    
    private func setData(_ values: [ChartByDate]?) {
        guard let values = values, values.count > 0 else {
            return
        }
        
        let data = CombinedChartData()
        data.lineData = generateLineChart(values)

        self.data = data
    }
    
    private func generateLineChart(_ values: [TradeChart]) -> LineChartData {
        let totalProfitDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].profit ?? 0)
        }
        
        lineChartDataSet = LineChartDataSet(values: totalProfitDataEntry, label: "Profit")
        
        return LineChartData(dataSet: lineChartDataSet)
    }
    
    private func generateLineChart(_ values: [Chart]) -> LineChartData {
        let totalProfitDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].totalProfit ?? 0)
        }
        
        lineChartDataSet = LineChartDataSet(values: totalProfitDataEntry, label: "Total profit")
        
        return LineChartData(dataSet: lineChartDataSet)
    }
    
    private func generateLineChart(_ values: [ChartByDate]) -> LineChartData {
        let totalProfitDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].value ?? 0)
        }
        
        lineChartDataSet = LineChartDataSet(values: totalProfitDataEntry, label: "Value")
        
        return LineChartData(dataSet: lineChartDataSet)
    }
}
