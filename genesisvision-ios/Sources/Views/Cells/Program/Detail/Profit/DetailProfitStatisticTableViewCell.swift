//
//  DetailProfitStatisticTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

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
