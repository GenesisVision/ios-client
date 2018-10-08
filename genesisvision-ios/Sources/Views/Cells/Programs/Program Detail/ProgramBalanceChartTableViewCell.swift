//
//  ProgramBalanceChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class ProgramBalanceChartTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var amountTitleLabel: UILabel! {
        didSet {
            amountTitleLabel.textColor = UIColor.Cell.subtitle
            amountTitleLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var amountValueLabel: UILabel! {
        didSet {
            amountValueLabel.textColor = UIColor.Cell.title
            amountValueLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var amountCurrencyLabel: UILabel! {
        didSet {
            amountCurrencyLabel.textColor = UIColor.Cell.subtitle
            amountCurrencyLabel.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var changeTitleLabel: UILabel! {
        didSet {
            changeTitleLabel.textColor = UIColor.Cell.subtitle
            changeTitleLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changePercentLabel: UILabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
            changePercentLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changeValueLabel: UILabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
            changeValueLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changeCurrencyLabel: UILabel! {
        didSet {
            changeCurrencyLabel.textColor = UIColor.Cell.subtitle
            changeCurrencyLabel.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.BaseView.bg
            chartView.isUserInteractionEnabled = true
            chartView.delegate = self
        }
    }
    
    let circleView: UIView = {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.SystemSizes.chartCircleHeight, height: Constants.SystemSizes.chartCircleHeight))
        circleView.backgroundColor = UIColor.BaseView.bg
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.Common.white.cgColor
        circleView.layer.borderWidth = 2.0
        circleView.isHidden = true
        circleView.clipsToBounds = true
        
        return circleView
    }()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        
        chartView.addSubview(circleView)
    }
}

extension ProgramBalanceChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        circleView.isHidden = true
    }
}
