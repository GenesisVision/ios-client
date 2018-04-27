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

class ChartView: CombinedChartView {

    // MARK: - Variables
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
            
            let gradientColors = [UIColor.white.cgColor, UIColor.primary.cgColor]
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
    }
    
    // MARK: - Public methods
    func setup(chartType: ChartType = .default, chartDataSet: [Chart]? = nil, tradeChartDataSet: [TradeChart]? = nil, chartByDateDataSet: [ChartByDate]? = nil, name: String? = "DataSet", currencyValue: String? = nil, chartDurationType: ChartDurationType? = nil) {
        self.chartType = chartType
        self.name = name
        self.chartDataSet = chartDataSet
        self.tradeChartDataSet = tradeChartDataSet
        self.chartByDateDataSet = chartByDateDataSet
        self.currencyValue = currencyValue ?? ""
        self.chartDurationType = chartDurationType ?? .day
        
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
    private func setup() {
        if chartType == .default, let firstValue = chartByDateDataSet?.first?.value, let lastValue = chartByDateDataSet?.last?.value {
            
            lineChartDataSet.setColor(firstValue > lastValue ? UIColor.Font.red : UIColor.primary)
        }
        
        doubleTapToZoomEnabled = chartType == .full
        dragEnabled = chartType != .default
        pinchZoomEnabled = chartType == .full

        highlightPerTapEnabled = chartType != .default
        highlightPerDragEnabled = chartType != .default
        highlightFullBarEnabled = chartType != .default
       
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.minimumFractionDigits = 0
        rightAxisFormatter.maximumFractionDigits = 1
        rightAxisFormatter.negativeSuffix = " " + currencyValue
        rightAxisFormatter.positiveSuffix = " " + currencyValue
        
        self.marker = marker
        
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

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = Int(value)
        let year = determineYear(forDays: days)
        let month = determineMonth(forDayOfYear: days)
        
        let monthName = months[month % months.count]
        let yearName = "\(year)"
        
        if let chart = chart,
            chart.visibleXRange > 30 * 6 {
            return monthName + yearName
        } else {
            let dayOfMonth = determineDayOfMonth(forDays: days, month: month + 12 * (year - 2016))
            var appendix: String
            
            switch dayOfMonth {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }
            
            return dayOfMonth == 0 ? "" : String(format: "%d\(appendix) \(monthName)", dayOfMonth)
        }
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
        // month is 0-based
        switch month {
        case 1:
            var is29Feb = false
            if year < 1582 {
                is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
            } else if year > 1582 {
                is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
            }
            
            return is29Feb ? 29 : 28
            
        case 3, 5, 8, 10:
            return 30
            
        default:
            return 31
        }
    }
    
    private func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            month += 1
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
        }
        
        return max(month, 0)
    }
    
    private func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = determineYear(forDays: days)
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
    private func determineYear(forDays days: Int) -> Int {
        switch days {
        case ...366: return 2016
        case 367...730: return 2017
        case 731...1094: return 2018
        case 1095...1458: return 2019
        default: return 2020
        }
    }
}
