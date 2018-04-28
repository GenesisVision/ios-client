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
            profitFromProgramsLabel.textColor = UIColor.Header.darkTitle
        }
    }
    
    @IBOutlet var investedAmountLabel: BalanceLabel! {
        didSet {
            investedAmountLabel.textColor = UIColor.Header.darkTitle
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
        
        
        contentView.backgroundColor = UIColor.Background.darkGray
        selectionStyle = .none
    }
    
}
