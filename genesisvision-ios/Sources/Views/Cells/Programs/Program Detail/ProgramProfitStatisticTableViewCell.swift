//
//  ProgramProfitStatisticTableViewCell.swift
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
    override func commonInit(){
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.semibold, size: 14.0)
    }
}

class SubtitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit(){
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.regular, size: 12.0)
    }
}

class MediumLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit(){
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.medium, size: 12.0)
    }
}


class ProgramProfitStatisticTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet var tradesCountValueLabel: TitleLabel!
    @IBOutlet var tradesCountTitleLabel: SubtitleLabel!
    
    @IBOutlet var tradesSuccessCountValueLabel: TitleLabel!
    @IBOutlet var tradesSuccessCountTitleLabel: SubtitleLabel!
    
    @IBOutlet var investedAmountValueLabel: TitleLabel!
    @IBOutlet var investedAmountTitleLabel: SubtitleLabel!
    
    @IBOutlet var startBalanceValueLabel: TitleLabel!
    @IBOutlet var startBalanceTitleLabel: SubtitleLabel!

    @IBOutlet var startDateValueLabel: TitleLabel!
    @IBOutlet var startDateTitleLabel: SubtitleLabel!
    
    @IBOutlet var investorsCountValueLabel: TitleLabel!
    @IBOutlet var investorsCountTitleLabel: SubtitleLabel!

    @IBOutlet var drawdownPercentValueLabel: TitleLabel!
    @IBOutlet var drawdownPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var sharpeRatioPercentValueLabel: TitleLabel!
    @IBOutlet var sharpeRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet var profitFactorPercentValueLabel: TitleLabel!
    @IBOutlet var profitFactorPercentTitleLabel: SubtitleLabel!
    
//    @IBOutlet var investedCurrencyValueLabel: TitleLabel!
//    @IBOutlet var investedCurrencyTitleLabel: SubtitleLabel!
//
//    @IBOutlet var startCurrencyValueLabel: TitleLabel!
//    @IBOutlet var startCurrencyTitleLabel: SubtitleLabel!
//
//    @IBOutlet var profitValueLabel: TitleLabel!
//    @IBOutlet var profitValueTitleLabel: SubtitleLabel!
//
//    @IBOutlet var profitPercentValueLabel: TitleLabel!
//    @IBOutlet var profitPercentTitleLabel: SubtitleLabel!
//
//    @IBOutlet var currentValueLabel: TitleLabel!
//    @IBOutlet var currentValueTitleLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Cell.bg
        selectionStyle = .none
    }
}
