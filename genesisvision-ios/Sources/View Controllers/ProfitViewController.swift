//
//  ProfitViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

final class ProfitViewModel {
    
}

class ProfitViewController: BaseViewController {

    var vc: UIViewController!
    
    @IBOutlet weak var amountTitleLabel: UILabel! {
        didSet {
            amountTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var amountValueLabel: UILabel! {
        didSet {
            amountValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var amountCurrencyLabel: UILabel! {
        didSet {
            amountCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var changeTitleLabel: UILabel! {
        didSet {
            changeTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var changePercentLabel: UILabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    @IBOutlet weak var changeValueLabel: UILabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var changeCurrencyLabel: UILabel! {
        didSet {
            changeCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterTitleLabel: UILabel! {
        didSet {
            filterTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var tradersFilterButton: UIButton!
    @IBOutlet weak var assetsFilterButton: UIButton!
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = true
            chartView.delegate = self
        }
    }
    
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filtersViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let lineChartData: [TradeChart] = [TradeChart(date: Date(), profit: 51.0),
                                   TradeChart(date: Date().addDays(1), profit: 14.0),
                                   TradeChart(date: Date().addDays(2), profit: 13.0),
                                   TradeChart(date: Date().addDays(3), profit: 26.0),
                                   TradeChart(date: Date().addDays(4), profit: 50.0),
                                   TradeChart(date: Date().addDays(5), profit: 15.0)]
        
        let barChartData: [TradeChart] = [TradeChart(date: Date(), profit: 51.0),
                                       TradeChart(date: Date().addDays(1), profit: 14.0),
                                       TradeChart(date: Date().addDays(2), profit: 13.0),
                                       TradeChart(date: Date().addDays(3), profit: 26.0),
                                       TradeChart(date: Date().addDays(4), profit: 50.0),
                                       TradeChart(date: Date().addDays(5), profit: 15.0)]
        
        chartView.setup(chartType: .detail, lineChartData: lineChartData, barChartData: barChartData, name: nil, currencyValue: nil, chartDurationType: .week)
    }

    // MARK: - Public methods
    func updateViewConstraints(_ yOffset: CGFloat) {
        
    }
    // MARK: - Private methods
}


extension ProfitViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}
