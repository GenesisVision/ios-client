//
//  ProgramDetailFullChartViewController.swift
//  genesisvision-ios
//
//  Created by George on 12/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTSegmentedControl
import Charts

class ProgramDetailFullChartViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: ProgramDetailFullChartViewModel!
    
    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var xTitleLabel: UILabel!
    @IBOutlet var yTitleLabel: UILabel!
    
    @IBOutlet var xValueLabel: UILabel!
    @IBOutlet var yValueLabel: UILabel!
    @IBOutlet var currencyValueLabel: CurrencyLabel!
    
    // MARK: - Views
    @IBOutlet var segmentedControl: TTSegmentedControl!
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = true
            chartView.backgroundColor = UIColor.Background.main
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
        
        view.backgroundColor = UIColor.Font.dark
        
        chartView.setup(chartType: .full, dataSet: viewModel.investmentProgramDetails?.chart, name: "Full Chart", currencyValue: viewModel.investmentProgramDetails?.currency?.rawValue)
        
        segmentedControl.itemTitles = viewModel.getAllChartDurationTypes()
        segmentedControl.selectItemAt(index: viewModel.getSelectedChartDurationTypes())
        segmentedControl.allowChangeThumbWidth = false
        segmentedControl.didSelectItemWith = { (index, title) -> () in
            self.viewModel.selectChartDurationTypes(index: index)
        }
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
