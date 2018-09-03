//
//  InvestorDashboardPortfolioTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/08/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BalanceView: UIStackView {
    @IBOutlet var balanceTitleLabel: UILabel! {
        didSet {
            balanceTitleLabel.font = UIFont.getFont(.regular, size: 17.0)
            balanceTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.font = UIFont.getFont(.bold, size: 21.0)
            balanceValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet var balanceCurrencyValueLabel: UILabel! {
        didSet {
            balanceCurrencyValueLabel.font = UIFont.getFont(.regular, size: 17.0)
            balanceCurrencyValueLabel.textColor = UIColor.Cell.subtitle
        }
    }
}

class ChangeView: UIStackView {
    @IBOutlet var changeTitleLabel: UILabel! {
        didSet {
            changeTitleLabel.font = UIFont.getFont(.regular, size: 17.0)
            changeTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet var changePercentLabel: UILabel! {
        didSet {
            changePercentLabel.font = UIFont.getFont(.bold, size: 21.0)
            changePercentLabel.textColor = UIColor.Cell.redTitle
        }
    }
    
    @IBOutlet var changeValueLabel: UILabel! {
        didSet {
            changeValueLabel.font = UIFont.getFont(.bold, size: 21.0)
            changeValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet var changeCurrencyValueLabel: UILabel! {
        didSet {
            changeCurrencyValueLabel.font = UIFont.getFont(.regular, size: 17.0)
            changeCurrencyValueLabel.textColor = UIColor.Cell.subtitle
        }
    }
}


class InRequestsView: UIStackView {
    @IBOutlet var inRequestsTitleLabel: UILabel! {
        didSet {
            inRequestsTitleLabel.font = UIFont.getFont(.regular, size: 17.0)
            inRequestsTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet var inRequestsValueLabel: UILabel! {
        didSet {
            inRequestsValueLabel.font = UIFont.getFont(.bold, size: 21.0)
            inRequestsValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet var inRequestsCurrencyValueLabel: UILabel! {
        didSet {
            inRequestsCurrencyValueLabel.font = UIFont.getFont(.regular, size: 17.0)
            inRequestsCurrencyValueLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet var inRequestsButton: UIButton!
}

class PortfolioView: UIView {
    
    @IBOutlet var balanceLabels: BalanceView!
    @IBOutlet var changeLabels: ChangeView!
    @IBOutlet var inRequestsView: InRequestsView!
    
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
            chartView.backgroundColor = UIColor.BaseView.bg
        }
    }
}

class ProfitView: UIView {
    
    @IBOutlet var balanceLabels: BalanceView!
    @IBOutlet var changeLabels: ChangeView!
    
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
            chartView.backgroundColor = UIColor.BaseView.bg
        }
    }
}

class InvestorDashboardPortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var portfolioView: PortfolioView!
    @IBOutlet weak var profitView: ProfitView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private methods
    func setupScrollView() {
        let viewWidth = self.frame.size.width
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: viewWidth * 2, height: 200.0)
        scrollView.delegate = self
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: viewWidth, height: 200.0), animated: false)
    }
    
    func setupSegmentedControl(with segments: [String]) {
        segmentedControl.removeAllSegments()
        
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        let textAttributes = [NSAttributedStringKey.font: UIFont.getFont(.bold, size: Constants.SystemSizes.unselectedSegmentedTitle),
                              NSAttributedStringKey.foregroundColor: UIColor.Cell.subtitle]
        let textSelectAttributes = [NSAttributedStringKey.font: UIFont.getFont(.bold, size: Constants.SystemSizes.selectedSegmentedTitle),
            NSAttributedStringKey.foregroundColor: UIColor.Cell.title]
        
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .selected)
        
        for (idx, segment) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment, at: idx, animated: true)
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let viewWidth = Double(self.frame.size.width)
        let xPosition: Double = viewWidth * Double(sender.selectedSegmentIndex)
        scrollView.scrollRectToVisible(CGRect(x: xPosition, y: 0.0, width: viewWidth, height: 200.0), animated: true)
    }
    
    // MARK: - Public methods
    func configure(with segments: [String]) {
        setupScrollView()
        setupSegmentedControl(with: segments)
    }
    
}

extension InvestorDashboardPortfolioTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.size.width
        let page: Int = Int(scrollView.contentOffset.x / pageWidth)
        
        segmentedControl.selectedSegmentIndex = page
    }
}
