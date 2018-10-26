//
//  DetailProfitStatisticTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.regular, size: 12.0)
    }
}

class TitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.semibold, size: 14.0)
    }
}

class SubtitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.regular, size: 12.0)
    }
}

class MediumLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.medium, size: 12.0)
    }
}


class DetailProfitStatisticTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    
    @IBOutlet var startDateStackView: UIStackView!
    @IBOutlet var startDateValueLabel: TitleLabel!
    @IBOutlet var startDateTitleLabel: SubtitleLabel!
    
    @IBOutlet var endDateStackView: UIStackView!
    @IBOutlet var endDateValueLabel: TitleLabel!
    @IBOutlet var endDateTitleLabel: SubtitleLabel!
    
    @IBOutlet var tradesSuccessCountStackView: UIStackView!
    @IBOutlet var tradesSuccessCountValueLabel: TitleLabel!
    @IBOutlet var tradesSuccessCountTitleLabel: SubtitleLabel!
    
    @IBOutlet var tradesCountStackView: UIStackView!
    @IBOutlet var tradesCountValueLabel: TitleLabel!
    @IBOutlet var tradesCountTitleLabel: SubtitleLabel!
    
    @IBOutlet var drawdownPercentStackView: UIStackView!
    @IBOutlet var drawdownPercentValueLabel: TitleLabel!
    @IBOutlet var drawdownPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var investorsCountStackView: UIStackView!
    @IBOutlet var investorsCountValueLabel: TitleLabel!
    @IBOutlet var investorsCountTitleLabel: SubtitleLabel!
    
    @IBOutlet var balanceStackView: UIStackView!
    @IBOutlet var balanceValueLabel: TitleLabel!
    @IBOutlet var balanceTitleLabel: SubtitleLabel!
    
    @IBOutlet var sharpeRatioPercentStackView: UIStackView!
    @IBOutlet var sharpeRatioPercentValueLabel: TitleLabel!
    @IBOutlet var sharpeRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var calmarRatioPercentStackView: UIStackView!
    @IBOutlet var calmarRatioPercentValueLabel: TitleLabel!
    @IBOutlet var calmarRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var sortinoRatioPercentStackView: UIStackView!
    @IBOutlet var sortinoRatioPercentValueLabel: TitleLabel!
    @IBOutlet var sortinoRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var profitFactorPercentStackView: UIStackView!
    @IBOutlet var profitFactorPercentValueLabel: TitleLabel!
    @IBOutlet var profitFactorPercentTitleLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
