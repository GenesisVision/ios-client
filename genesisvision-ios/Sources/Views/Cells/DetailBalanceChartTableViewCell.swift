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
    
    @IBOutlet weak var roundedBackgroundView: RoundedBackgroundView! {
        didSet {
            roundedBackgroundView.isHidden = true
        }
    }
        
    @IBOutlet weak var investorsFundsTitleLabel: SubtitleLabel! {
        didSet {
            investorsFundsTitleLabel.isHidden = true
            investorsFundsTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var investorsFundsValueLabel: TitleLabel! {
        didSet {
            investorsFundsValueLabel.isHidden = true
            investorsFundsValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var managersFundsTitleLabel: SubtitleLabel! {
        didSet {
            managersFundsTitleLabel.isHidden = true
            managersFundsTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var managersFundsValueLabel: TitleLabel! {
        didSet {
            managersFundsValueLabel.isHidden = true
            managersFundsValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var profitStackView: UIStackView! {
        didSet {
            profitStackView.isHidden = true
        }
    }
    @IBOutlet weak var profitTitleLabel: SubtitleLabel! {
        didSet {
            profitTitleLabel.isHidden = true
            profitTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var profitValueLabel: TitleLabel! {
        didSet {
            profitValueLabel.isHidden = true
            profitValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var dateValueLabel: SubtitleLabel! {
        didSet {
            dateValueLabel.isHidden = true
            dateValueLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.BaseView.bg
            chartView.isUserInteractionEnabled = false
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

    var chartModel: Any?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        
        chartView.addSubview(circleView)
    }
    
    func configure(model: Any) {
        self.chartModel = model
    }
}

extension DetailBalanceChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.isHidden = false
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
        let date = Date(timeIntervalSince1970: entry.x)
        chartViewProtocol?.chartValueSelected(date: date)
        
        if let model = chartModel as? FundBalanceChart {
            if let result = model.balanceChart?.first(where: { $0.date == date }) {
                roundedBackgroundView.isHidden = false
                
                if let managerFunds = result.managerFunds {
                    managersFundsTitleLabel.isHidden = false
                    managersFundsValueLabel.isHidden = false
                    
                    managersFundsValueLabel.text = managerFunds.rounded(withType: .gvt).toString()
                    managersFundsValueLabel.sizeToFit()
                }
                
                if let investorsFunds = result.investorsFunds {
                    investorsFundsTitleLabel.isHidden = false
                    investorsFundsValueLabel.isHidden = false
                    
                    investorsFundsValueLabel.text = investorsFunds.rounded(withType: .gvt).toString()
                    investorsFundsValueLabel.sizeToFit()
                }
                
                if let date = result.date {
                    dateValueLabel.isHidden = false
                    dateValueLabel.text = date.dateAndTimeFormatString
                    dateValueLabel.sizeToFit()
                }
            }
        } else if let model = chartModel as? ProgramBalanceChart {
            if let result = model.balanceChart?.first(where: { $0.date == date }) {
                guard let programCurrency = model.programCurrency else { return }
                let currency = CurrencyType(rawValue: programCurrency.rawValue) ?? .gvt
                
                roundedBackgroundView.isHidden = false
                
                if let profit = result.profit {
                    profitStackView.isHidden = false
                    profitTitleLabel.isHidden = false
                    profitValueLabel.isHidden = false
                    
                    profitValueLabel.text = profit.rounded(withType: currency).toString()
                }
                
                if let managerFunds = result.managerFunds {
                    managersFundsTitleLabel.isHidden = false
                    managersFundsValueLabel.isHidden = false
                    
                    managersFundsValueLabel.text = managerFunds.rounded(withType: currency).toString()
                }
                
                if let investorsFunds = result.investorsFunds {
                    investorsFundsTitleLabel.isHidden = false
                    investorsFundsValueLabel.isHidden = false
                    
                    investorsFundsValueLabel.text = investorsFunds.rounded(withType: currency).toString()
                }
                
                if let date = result.date {
                    dateValueLabel.isHidden = false
                    dateValueLabel.text = date.dateAndTimeFormatString
                }
            }
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        circleView.isHidden = true
        chartViewProtocol?.chartValueNothingSelected()
        
        roundedBackgroundView.isHidden = true
        
        profitStackView.isHidden = true
        profitTitleLabel.isHidden = true
        profitValueLabel.isHidden = true
        
        managersFundsTitleLabel.isHidden = true
        managersFundsValueLabel.isHidden = true
        
        investorsFundsTitleLabel.isHidden = true
        investorsFundsValueLabel.isHidden = true
        
        dateValueLabel.isHidden = true
    }
}
