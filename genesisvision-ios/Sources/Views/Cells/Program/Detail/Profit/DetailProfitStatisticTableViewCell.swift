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
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    
    @IBOutlet weak var startDateStackView: UIStackView!
    @IBOutlet weak var startDateValueLabel: TitleLabel!
    @IBOutlet weak var startDateTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var endDateStackView: UIStackView!
    @IBOutlet weak var endDateValueLabel: TitleLabel!
    @IBOutlet weak var endDateTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var tradesSuccessCountStackView: UIStackView!
    @IBOutlet weak var tradesSuccessCountValueLabel: TitleLabel!
    @IBOutlet weak var tradesSuccessCountTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var tradesCountStackView: UIStackView!
    @IBOutlet weak var tradesCountValueLabel: TitleLabel!
    @IBOutlet weak var tradesCountTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var drawdownPercentStackView: UIStackView!
    @IBOutlet weak var drawdownPercentValueLabel: TitleLabel!
    @IBOutlet weak var drawdownPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var investorsCountStackView: UIStackView!
    @IBOutlet weak var investorsCountValueLabel: TitleLabel!
    @IBOutlet weak var investorsCountTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var balanceStackView: UIStackView!
    @IBOutlet weak var balanceValueLabel: TitleLabel!
    @IBOutlet weak var balanceTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var sharpeRatioPercentStackView: UIStackView!
    @IBOutlet weak var sharpeRatioPercentValueLabel: TitleLabel!
    @IBOutlet weak var sharpeRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var calmarRatioPercentStackView: UIStackView!
    @IBOutlet weak var calmarRatioPercentValueLabel: TitleLabel!
    @IBOutlet weak var calmarRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var sortinoRatioPercentStackView: UIStackView!
    @IBOutlet weak var sortinoRatioPercentValueLabel: TitleLabel!
    @IBOutlet weak var sortinoRatioPercentTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var profitFactorPercentStackView: UIStackView!
    @IBOutlet weak var profitFactorPercentValueLabel: TitleLabel!
    @IBOutlet weak var profitFactorPercentTitleLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
