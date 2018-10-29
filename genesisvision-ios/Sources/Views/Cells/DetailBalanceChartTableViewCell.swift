//
//  DetailBalanceChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class DetailBalanceChartTableViewCell: UITableViewCell {

    weak var chartViewProtocol: ChartViewProtocol?
    
    // MARK: - Outlets
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            chartViewHeightConstraint.constant = 0.0
        }
    }
    @IBOutlet weak var amountTitleLabel: SubtitleLabel! {
        didSet {
            amountTitleLabel.textColor = UIColor.Cell.subtitle
            amountTitleLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var amountValueLabel: TitleLabel! {
        didSet {
            amountValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var amountCurrencyLabel: SubtitleLabel! {
        didSet {
            amountCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var changeTitleLabel: SubtitleLabel! {
        didSet {
            changeTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var changePercentLabel: SubtitleLabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    @IBOutlet weak var changeValueLabel: TitleLabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var changeCurrencyLabel: SubtitleLabel! {
        didSet {
            changeCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
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
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        
        chartView.addSubview(circleView)
    }
}

extension DetailBalanceChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.isHidden = false
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
        let date = Date(timeIntervalSince1970: entry.x)
        chartViewProtocol?.chartValueSelected(date: date)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        circleView.isHidden = true
        chartViewProtocol?.chartValueNothingSelected()
    }
}