//
//  ChartView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Charts

class MyFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return dataProvider.maxHighlightDistance
    }
    
}

class ChartView: CombinedChartView {

    // MARK: - Variables
    weak var chartViewProtocol: ChartViewProtocol?

    private var barChartData: [ValueChartBar]?
    private var lineChartData: [ChartSimple]?
    private var balanceChartData: [ProgramBalanceChartElement]?
    
    private var name: String?
    private var currencyValue: String = ""
    
    private var chartType: ChartType = .detail
    private var chartDurationType: ChartDurationType!
    
    private var minLimitLine: ChartLimitLine!
    private var maxLimitLine: ChartLimitLine!
    
    private var minLimitValue: Double = 0.0
    private var maxLimitValue: Double = 0.0
    
    private var lineChartDataSet: LineChartDataSet! {
        didSet {
            lineChartDataSet.setColor(UIColor.primary)
            lineChartDataSet.lineWidth = 1.5

            lineChartDataSet.drawFilledEnabled = chartType != .default
            lineChartDataSet.fillFormatter = MyFillFormatter()

            let gradientColors = [UIColor.primary.withAlphaComponent(0.3).cgColor, UIColor.primary.withAlphaComponent(0.0).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

            lineChartDataSet.fillAlpha = 0.3
            lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90)

            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawIconsEnabled = false

            lineChartDataSet.highlightEnabled = true
            lineChartDataSet.highlightColor = UIColor.Font.dark
            lineChartDataSet.setDrawHighlightIndicators(true)
            lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true

            lineChartDataSet.drawValuesEnabled = false
            lineChartDataSet.drawCircleHoleEnabled = false
            lineChartDataSet.mode = .horizontalBezier
        }
    }
    
    private var barChartDataSet: BarChartDataSet! {
        didSet {
            barChartDataSet.setColor(UIColor.Cell.title)
//            barChartDataSet.axisDependency = .left
            barChartDataSet.drawValuesEnabled = false
            barChartDataSet.highlightEnabled = false
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    // MARK: - Public methods
    func setup(chartType: ChartType = .detail,
               lineChartData: [ChartSimple]? = nil,
               barChartData: [ValueChartBar]? = nil,
               balanceChartData: [ProgramBalanceChartElement]? = nil,
               name: String? = "DataSet",
               currencyValue: String? = nil,
               chartDurationType: ChartDurationType? = nil) {
        
        self.chartType = chartType
        self.name = name
        self.lineChartData = lineChartData
        self.barChartData = barChartData
        self.balanceChartData = balanceChartData
        self.currencyValue = currencyValue ?? ""
        self.chartDurationType = chartDurationType ?? .all

        updateData()
        
        setup()
    }
    
    func updateData() {
        let data = CombinedChartData()
        
        if let lineChartData = lineChartData {
            data.lineData = generateLineChartData(lineChartData)
            
            data.lineData.calcMinMax()
            maxLimitValue = data.lineData.getYMax().rounded(toPlaces: 2)
            minLimitValue = data.lineData.getYMin().rounded(toPlaces: 2)
        }
        
        if let barChartData = barChartData {
            data.barData = generateBarChartData(barChartData)
        }
        
        if let balanceChartData = balanceChartData {
            let lineData = generateBalanceChartData(balanceChartData)
            data.lineData = lineData
            
            data.lineData.calcMinMax()
            maxLimitValue = data.lineData.getYMax().rounded(toPlaces: 2)
            minLimitValue = data.lineData.getYMin().rounded(toPlaces: 2)
        }
        
        xAxis.axisMaximum = data.xMax + (Date().addDays(1).timeIntervalSince1970 - Date().timeIntervalSince1970) / 10
        xAxis.axisMinimum = data.xMin - (Date().addDays(1).timeIntervalSince1970 - Date().timeIntervalSince1970) / 10
        
        self.data = data
    }
    
    // MARK: - Private methods
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .ended, .cancelled:
            highlightValue(nil, callDelegate: false)
            chartViewProtocol?.chartValueNothingSelected()
        case .changed:
//            chartViewProtocol?.chartValueSelected(entry: Date())
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
        
        if chartType == .default, let firstValue = lineChartData?.first?.value, let lastValue = lineChartData?.last?.value {
            lineChartDataSet.setColor(firstValue > lastValue ? UIColor.Font.red : UIColor.primary)
        }

        scaleXEnabled = chartType == .full
        scaleYEnabled = chartType == .full
        doubleTapToZoomEnabled = chartType == .full
        dragEnabled = chartType != .default
        pinchZoomEnabled = chartType == .full

        highlightPerTapEnabled = chartType != .default
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
        rightAxis.removeAllLimitLines()
        
        if chartType != .default {
            //Limits
            maxLimitLine = ChartLimitLine(limit: maxLimitValue, label: "\(maxLimitValue)")
            maxLimitLine.lineWidth = 1
            maxLimitLine.lineDashLengths = [1.0, 8.0]
            maxLimitLine.labelPosition = .rightBottom
            maxLimitLine.valueTextColor = UIColor.Cell.title
            maxLimitLine.lineColor = UIColor.Cell.subtitle
            maxLimitLine.valueFont = UIFont.getFont(.regular, size: 10.0)
            rightAxis.addLimitLine(maxLimitLine)
            
            minLimitLine = ChartLimitLine(limit: minLimitValue, label: "\(minLimitValue)")
            minLimitLine.lineWidth = 1
            minLimitLine.lineDashLengths = [1.0, 8.0]
            minLimitLine.labelPosition = .rightTop
            minLimitLine.valueTextColor = UIColor.Cell.title
            minLimitLine.lineColor = UIColor.Cell.subtitle
            minLimitLine.valueFont = UIFont.getFont(.regular, size: 10.0)
            rightAxis.addLimitLine(minLimitLine)
        }
        
        rightAxis.centerAxisLabelsEnabled = true
        
        rightAxis.gridLineDashLengths = [3.0, 3.0]
        rightAxis.drawLimitLinesBehindDataEnabled = true

        //grid
        rightAxis.drawGridLinesEnabled = false
        rightAxis.gridColor = UIColor.Cell.subtitle
        rightAxis.gridLineDashLengths = [3.0, 3.0]
        rightAxis.gridLineWidth = 1.0

        //axis
        rightAxis.drawLabelsEnabled = chartType == .full
        rightAxis.drawAxisLineEnabled = chartType == .full
        rightAxis.axisLineWidth = 2.0
        rightAxis.axisLineColor = UIColor.Font.dark
        rightAxis.labelFont = UIFont.getFont(.light, size: 13)

        //yZeroLine
        rightAxis.drawZeroLineEnabled = chartType == .default
        rightAxis.zeroLineColor = UIColor.Cell.separator
        rightAxis.zeroLineWidth = 1.0
        rightAxis.zeroLineDashLengths = chartType == .default ? [2.0, 2.0] : [2.0, 6.0]

        drawGridBackgroundEnabled = false

        //xAxis
        xAxis.drawGridLinesEnabled = false

        xAxis.axisLineWidth = 0.0
        xAxis.axisLineColor = UIColor.Font.dark

        xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let date = Date(timeIntervalSince1970: index)
            
            let timeInterval = date.timeIntervalSinceNow
            if timeInterval / 60 / 60 < 24 {
                return "Today"
            }
            
            let dateString = Date.getFormatStringForChart(for: date, chartDurationType: self.chartDurationType)
            return dateString
        })

//        xAxis.labelRotationAngle = 0.3
        xAxis.labelFont = UIFont.getFont(.light, size: 13)
        xAxis.labelTextColor = UIColor.Cell.subtitle
        xAxis.labelPosition = .bottom
        
        xAxis.enabled = chartType != .default

        chartDescription?.enabled = false

        legend.enabled = false
        autoScaleMinMaxEnabled = true
        
        drawBarShadowEnabled = false
        highlightFullBarEnabled = true

        drawOrder = [DrawOrder.bar.rawValue,
                     DrawOrder.line.rawValue]

        if chartType != .default {
            animate(xAxisDuration: 0.5)
        }
    }
    
    private func generateBalanceChartData(_ values: [ProgramBalanceChartElement]) -> LineChartData {
        let lineChartData = LineChartData()
        let profitDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].profit ?? 0)
        }
        lineChartDataSet = LineChartDataSet(values: profitDataEntry, label: "Profit Chart")
        lineChartDataSet.setColor(.red)
        lineChartDataSet.highlightEnabled = false
        lineChartData.addDataSet(lineChartDataSet)
        
        let managerFundsDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].managerFunds ?? 0)
        }
        lineChartDataSet = LineChartDataSet(values: managerFundsDataEntry, label: "Manager Funds Chart")
        lineChartDataSet.setColor(.yellow)
        lineChartDataSet.highlightEnabled = false
        lineChartData.addDataSet(lineChartDataSet)
        
        
        let investorsFundsDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].investorsFunds ?? 0)
        }
        lineChartDataSet = LineChartDataSet(values: investorsFundsDataEntry, label: "Investors Funds Chart")
        lineChartDataSet.setColor(.blue)
        lineChartDataSet.highlightEnabled = chartType != .default
        lineChartData.addDataSet(lineChartDataSet)
        
        return lineChartData
    }
    
    
    private func generateLineChartData(_ values: [ChartSimple]) -> LineChartData {

        let totalDataEntry = (0..<values.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].value ?? 0)
        }
        
        lineChartDataSet = LineChartDataSet(values: totalDataEntry, label: "Line Profit")
        
        return LineChartData(dataSet: lineChartDataSet)
    }
    
    private func generateBarChartData(_ values: [ValueChartBar]) -> BarChartData {
        let totalDataEntry = (0..<values.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: values[i].date?.timeIntervalSince1970 ?? 0, y: values[i].value ?? 0)
        }
        
        barChartDataSet = BarChartDataSet(values: totalDataEntry, label: "Bar profit")

        let barChartData = BarChartData(dataSet: barChartDataSet)
        if let chartDurationType = chartDurationType {
            switch chartDurationType {
            case .day:
                barChartData.barWidth = 10.0
            default:
                barChartData.barWidth = (Date().addDays(1).timeIntervalSince1970 - Date().timeIntervalSince1970) / 10
            }
        }
        
        return barChartData
    }
}
