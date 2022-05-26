//
//  CoinAssetDetailViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 21.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import Charts

protocol ChartViewDelegateProtocol: AnyObject {
    func pushDataToChartView(dataSet: CandleChartDataSet, xAxisValueFormatter: MyXAxisFormatter)
    func noChartDataSetup()
}

protocol AssetPortfolioDelegateProtocol: AnyObject {
    func pushPortfolioData(assetPortfolio: CoinsAsset?)
    func updateAssetData()
}

protocol CoinAssetDetailViewModelProtocol {
    var intervals: [KlineIntervalButton] { get }
    var coinAsset: CoinsAsset? { get }
    var portfolio: CoinsAsset? { get }
    var tickerSymbol: String? { get }
    func deleteChartValues()
    func setupIntervalButtons(indexPath : IndexPath)
    func fetchCoinsPortfolio()
}

protocol CoinAssetDetailViewModelChartProtocol {
    func setupChartValues(interval: BinanceKlineInterval)
    func updateChartValues(indexPath: IndexPath)
    func deleteChartValues()
}

class CoinAssetDetailViewModel {
    var asset: CoinsAsset?
    var assetPortfolio: CoinsAsset?
    var fullSymbol: String?
    private var chartValues = [CandleChartDataEntry]()
    private var dateRange = FilterDateRangeModel()
    private weak var chartViewDelegate: ChartViewDelegateProtocol?
    private weak var assetPortfolioDelegate: AssetPortfolioDelegateProtocol?
    private(set) var interval: BinanceKlineInterval = .oneHour
    private var intervalButtons = [KlineIntervalButton(title: .oneMinute, interval: .oneMinute),
                           KlineIntervalButton(title: .threeMinutes, interval: .threeMinutes),
                           KlineIntervalButton(title: .fiveMinutes, interval: .fiveMinutes),
                           KlineIntervalButton(title: .fifteenMinutes, interval: .fifteenMinutes),
                           KlineIntervalButton(title: .thirtyMinutes, interval: .thirtyMinutes),
                           KlineIntervalButton(title: .oneHour, interval: .oneHour, isCurrent: true),
                           KlineIntervalButton(title: .twoHour, interval: .twoHour),
                           KlineIntervalButton(title: .fourHour, interval: .fourHour),
                           KlineIntervalButton(title: .sixHour, interval: .sixHour),
                           KlineIntervalButton(title: .twelveHour, interval: .twelveHour),
                           KlineIntervalButton(title: .oneDay, interval: .oneDay),
                           KlineIntervalButton(title: .threeDay, interval: .threeDay),
                           KlineIntervalButton(title: .oneWeek, interval: .oneWeek),
                           KlineIntervalButton(title: .oneMonth, interval: .oneMonth)
    ]
    
    init(asset: CoinsAsset, chartViewDelegate: ChartViewDelegateProtocol, assetPortfolioDelegate: AssetPortfolioDelegateProtocol) {
        self.asset = asset
        self.chartViewDelegate = chartViewDelegate
        self.assetPortfolioDelegate = assetPortfolioDelegate
        self.fetchCoinsPortfolio()
        self.setupChartValues(interval: interval)
    }
    init(assetId: String, chartViewDelegate: ChartViewDelegateProtocol, assetPortfolioDelegate: AssetPortfolioDelegateProtocol) {
        self.asset = CoinsAsset()
        self.chartViewDelegate = chartViewDelegate
        self.assetPortfolioDelegate = assetPortfolioDelegate
        self.fetchAsset(id: assetId) { (viewModel) in
            self.asset = viewModel?.items?.first
            self.fetchCoinsPortfolio()
            self.setupChartValues(interval: self.interval)
            self.assetPortfolioDelegate?.updateAssetData()
        }
    }
}

extension CoinAssetDetailViewModel: CoinAssetDetailViewModelProtocol {
    var portfolio: CoinsAsset? {
        assetPortfolio
    }
    
    var tickerSymbol: String? {
        fullSymbol
    }
    var coinAsset: CoinsAsset? {
        asset
    }
    var intervals: [KlineIntervalButton] {
        intervalButtons
    }
    func setupIntervalButtons(indexPath: IndexPath) {
        guard indexPath.item <= intervalButtons.count else { return }
        for (index, _ ) in intervalButtons.enumerated() {
            intervalButtons[index].isCurrent = false
        }
        intervalButtons[indexPath.item].isCurrent = true
        let selectedInterval = intervalButtons[indexPath.item]
        interval = selectedInterval.interval
    }
}

extension CoinAssetDetailViewModel: CoinAssetDetailViewModelChartProtocol {
    
    func setupChartValues(interval: BinanceKlineInterval) {
        
        guard let symbol = asset?.details?.symbol?.uppercased() else { return }
        
        switch symbol {
        case Currency.btc.rawValue.uppercased():
            fullSymbol = symbol.uppercased() + Currency.usdt.rawValue.uppercased()
        case Currency.usdt.rawValue.uppercased():
            fullSymbol = Currency.btc.rawValue.uppercased() + Currency.usdt.rawValue.uppercased()
        default:
            fullSymbol = symbol.uppercased() + Currency.btc.rawValue.uppercased()
        }
        
        guard let fullSymbol = fullSymbol else { return }
        
        CoinAssetsDataProvider.getKlines(symbol: fullSymbol, interval: interval) { viewModel in
            guard let items = viewModel?.items else { return }
            var xVlaues = [Double]()
            for (index,elem) in items.enumerated() {
    
                guard let openTime = elem.openTime?.timeIntervalSince1970,
                      let high = elem.high,
                      let low = elem.low,
                      let openValue = elem._open,
                      let closeValue = elem.close else { return }
                let chartData = CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: openValue, close: closeValue)
                xVlaues.append(openTime)
                self.chartValues.append(chartData)
            }
            DispatchQueue.main.async {
                let dataSet = CandleChartDataSet(entries: self.chartValues, label: "Data Set")
                guard self.chartViewDelegate != nil else { return }
                let dateFormat = Date.getDateFormatFromeBinanceKlineInterval(interval: interval)
                let xAxisValueFormatter = MyXAxisFormatter(dateFormat: dateFormat, xVlaues: xVlaues)
                self.chartViewDelegate?.pushDataToChartView(dataSet: dataSet, xAxisValueFormatter : xAxisValueFormatter)
            }
            
        } errorCompletion: { result in
            print(result)
            self.chartViewDelegate?.noChartDataSetup()
        }
    }
    
    func fetchAsset(id: String, complition: @escaping (_ coinAssetsViewModel: CoinsAssetItemsViewModel?)->()) {
        CoinAssetsDataProvider.get(assets: [id]) { coinAssetsViewModel in
            complition(coinAssetsViewModel)
        } errorCompletion: { result in
            print(result)
        }
    }
    
    func fetchCoinsPortfolio() {
        guard let symbol = asset?.details?.symbol?.uppercased() else { return }
        CoinAssetsDataProvider.getCoinsPortfolio(assets: [symbol], completion: { viewModel in
            let items = viewModel?.items
            let portfolioAsset = items?.first
            self.assetPortfolio = portfolioAsset
            self.assetPortfolioDelegate?.pushPortfolioData(assetPortfolio: portfolioAsset)
        }, errorCompletion: { _ in })
    }
    
    func deleteChartValues() {
        chartValues.removeAll()
    }
    
    func updateChartValues(indexPath: IndexPath) {
        guard indexPath.item <= intervals.count else { return }
        let interval = intervals[indexPath.item].interval
        deleteChartValues()
        setupChartValues(interval: interval)
    }
}

