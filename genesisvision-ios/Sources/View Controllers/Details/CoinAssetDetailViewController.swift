//
//  CoinAssetDetailViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 21.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit
import Charts


class CoinAssetDetailViewController : UIViewController {
    
    var viewModel : CoinAssetDetailViewModel?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.backgroundColor = .clear
            segmentedControl.tintColor = .clear
            
            segmentedControl.removeAllSegments()
            segmentedControl.insertSegment(withTitle: "First", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "Second", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "Third", at: 2, animated: true)
            
            segmentedControl.selectedSegmentIndex = 0
            
            segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
            segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)
            
            let clearImage = UIImage.imageWithColor(color: UIColor.clear)
            segmentedControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            segmentedControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
            segmentedControl.setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
            
        }
    }
    
    @IBOutlet weak var lineChartView: LineChartView! {
        didSet {
            lineChartViewSetup()
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "The theory behind Bitcoin was first described by Satoshi Nakomoto in a paper “Bitcoin: A Peer to Peer Electronic Cash System”published to a cryptographic mailing list on the 31st of October 2008. The total supply of Bitcoins is capped at 21 million coins (roughly 18 million are currently in circulation), with each coin being divisible to the 8th decimal place, with a single unit of the smallest division (0.00000001 BTC) being known colloquially as a Satoshi (or sat). The software to run miners and wallets is open source and decentralized, meaning that the network is accessible to anyone with a computer and an internet connection. Transactions are validated and written into the blockchain by miners selected via the Proof of Work (SHA-256) protocol.The theory behind Bitcoin was first described by Satoshi Nakomoto in a paper “Bitcoin: A Peer to Peer Electronic Cash System”published to a cryptographic mailing list on the 31st of October 2008. The total supply of Bitcoins is capped at 21 million coins (roughly 18 million are currently in circulation), with each coin being divisible to the 8th decimal place, with a single unit of the smallest division (0.00000001 BTC) being known colloquially as a Satoshi (or sat). The software to run miners and wallets is open source and decentralized, meaning that the network is accessible to anyone with a computer and an internet connection. Transactions are validated and written into the blockchain by miners selected via the Proof of Work (SHA-256) protocol."
        }
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        
        
        
        DispatchQueue.main.async {
        let yVals1 = (0..<10).map { (i) -> CandleChartDataEntry in
            let mult = 50 + 1
            let val = Double(Int(arc4random_uniform(40)) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "AppIcon"))
        }
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
            set1.axisDependency = .left
               set1.setColor(UIColor(white: 80/255, alpha: 1))
               set1.drawIconsEnabled = false
               set1.shadowColor = .darkGray
               set1.shadowWidth = 0.7
               set1.decreasingColor = .red
               set1.decreasingFilled = true
               set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
               set1.increasingFilled = false
               set1.neutralColor = .blue
        let data = CandleChartData(dataSet: set1)
        let dateFormat = "MMM d"
        let xAxisValueFormatter = MyXAxisFormatter(dateFormat: dateFormat)
        self.lineChartView.data = data
        self.lineChartView.xAxis.valueFormatter = xAxisValueFormatter
    }
    }
    
}

extension CoinAssetDetailViewController : ChartViewDelegateProtocol, ChartViewDelegate {
    func lineChartViewSetup() {
        lineChartView.backgroundColor = UIColor.BaseView.bg
//        lineChartView.backgroundColor = .cyan
//        lineChartView.leftAxis.enabled = false
//        lineChartView.xAxis.setLabelCount(5, force: false)
//        lineChartView.rightAxis.setLabelCount(8, force: false)
//        lineChartView.xAxis.labelPosition = .bottom
//        lineChartView.xAxis.labelTextColor = .white
//        lineChartView.rightAxis.labelTextColor = .white
//        lineChartView.animate(xAxisDuration: 0.8)
    }
    
    func pushDataToChartView(candleChartData : CandleChartData, xAxisValueFormatter : MyXAxisFormatter) {
        DispatchQueue.main.async {
            self.lineChartView.data = candleChartData
            self.lineChartView.xAxis.valueFormatter = xAxisValueFormatter
            self.lineChartView.reloadInputViews()
        }
    }
}
