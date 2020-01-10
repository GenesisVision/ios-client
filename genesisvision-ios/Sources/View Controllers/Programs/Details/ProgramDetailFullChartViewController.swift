//
//  ProgramDetailFullChartViewController.swift
//  genesisvision-ios
//
//  Created by George on 12/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class ProgramDetailFullChartViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: ProgramDetailFullChartViewModel!
    
    // MARK: - Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var xTitleLabel: UILabel!
    @IBOutlet weak var yTitleLabel: UILabel!
    
    @IBOutlet weak var xValueLabel: UILabel!
    @IBOutlet weak var yValueLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: CurrencyLabel!
    
    // MARK: - Views
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = true
            chartView.delegate = self
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        titleLabel.text = viewModel.title
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        
        currencyValueLabel.text = viewModel.getCurrencyValue()
        
//        chartView.setup(chartType: .full, chartDataSet: viewModel.programDetailsFull?.chart, name: "Full Chart", currencyValue: viewModel.programDetailsFull?.currency?.rawValue)
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        viewModel?.dismissVC()
    }
}

extension ProgramDetailFullChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let date = Date(timeIntervalSince1970: entry.x)
        let dateString = date.dateAndTimeFormatString
        
        xTitleLabel.text = "Date"
        yTitleLabel.text = "Amount " + viewModel.getCurrencyValue()
        
        xValueLabel.text = dateString
        yValueLabel.text = entry.y.toString()
    }
}
