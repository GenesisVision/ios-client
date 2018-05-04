//
//  DashboardHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardHeaderTableViewCell: UITableViewCell {

    // MARK: - Labels
    @IBOutlet var profitFromProgramsLabel: BalanceLabel! {
        didSet {
            profitFromProgramsLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var profitFromProgramsTitleLabel: UILabel! {
        didSet {
            profitFromProgramsTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    @IBOutlet var investedAmountLabel: BalanceLabel! {
        didSet {
            investedAmountLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var investedAmountTitleLabel: UILabel! {
        didSet {
            investedAmountTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    @IBOutlet var portfolioProfitTooltip: TooltipButton! {
        didSet {
            portfolioProfitTooltip.tooltipText = String.Tooltitps.portfolioProfit
        }
    }
    
    @IBOutlet var portfolioInvestedTooltip: TooltipButton! {
        didSet {
            portfolioInvestedTooltip.tooltipText = String.Tooltitps.portfolioInvested
        }
    }
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
}
