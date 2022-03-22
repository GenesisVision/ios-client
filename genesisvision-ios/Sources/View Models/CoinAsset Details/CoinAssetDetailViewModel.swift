//
//  CoinAssetDetailViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 21.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import Charts


protocol ChartViewDelegateProtocol : AnyObject {
    func pushDataToChartView(candleChartData : CandleChartData, xAxisValueFormatter : MyXAxisFormatter)
}

class CoinAssetDetailViewModel {
    let asset: CoinsAsset?
    var chartValues = [CandleChartDataEntry]()
    var dateRange = FilterDateRangeModel()
    weak var chartViewDelegate : ChartViewDelegateProtocol?
    
    init(asset: CoinsAsset) {
        self.asset = asset
//        self.setupChartValues(asset: asset)
//        setupChartValues2()
    }
    
    func setupChartValues(asset: CoinsAsset) {
        guard let symbol = asset.details?.symbol else { return }
        CoinAssetsDataProvider.getKlines(symbol: symbol, interval: .oneMonth) { viewModel in
            guard let items = viewModel?.items else { return }
            for elem in items {
                guard let openTime = elem.openTime?.timeIntervalSince1970,
                      let high = elem.high,
                      let low = elem.low,
                      let openValue = elem._open,
                      let closeValue = elem.close else { return }
                print(openTime)
                print(high)
                print(low)
                print(openValue)
                print(closeValue)
                
                let chartData = CandleChartDataEntry(x: openTime, shadowH: high, shadowL: low, open: openValue, close: closeValue)
                self.chartValues.append(chartData)
            }
            DispatchQueue.main.async {
                let dataSet = CandleChartDataSet(entries: self.chartValues, label: "Data Set")
                let data = CandleChartData(dataSet: dataSet)
                guard self.chartViewDelegate != nil else { return }
                let dateFormat = "MMM d"
                let xAxisValueFormatter = MyXAxisFormatter(dateFormat: dateFormat)
//                self.chartViewDelegate?.pushDataToChartView(candleChartData: data, xAxisValueFormatter : xAxisValueFormatter)
            }
            
        } errorCompletion: { result in
            print(result)
        }
    }
    func setupChartValues2() {
        DispatchQueue.main.async {
            let yVals1 = (0..<10).map { (i) -> CandleChartDataEntry in
                let mult = 50 + 1
                let val = Double(Int(arc4random_uniform(40)) + mult)
                let high = Double(arc4random_uniform(9) + 8)
                let low = Double(arc4random_uniform(9) + 8)
                let open = Double(arc4random_uniform(6) + 1)
                let close = Double(arc4random_uniform(6) + 1)
                let even = i % 2 == 0
                
                return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close)
            }
            
            let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
            let data = CandleChartData(dataSet: set1)
            let dateFormat = "MMM d"
            let xAxisValueFormatter = MyXAxisFormatter(dateFormat: dateFormat)
            self.chartViewDelegate?.pushDataToChartView(candleChartData: data, xAxisValueFormatter : xAxisValueFormatter)
        }
    }
}

class MyXAxisFormatter : NSObject, IAxisValueFormatter {
    
    var dateFormat : String
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(value) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    init(dateFormat: String) {
        self.dateFormat = dateFormat
    }
}
