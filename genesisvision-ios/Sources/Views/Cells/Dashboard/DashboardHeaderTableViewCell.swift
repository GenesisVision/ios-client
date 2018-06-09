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
    @IBOutlet var portfolioProfitCurrencyLabel: CurrencyLabel! {
        didSet {
            portfolioProfitCurrencyLabel.currencyType = .gvt
        }
    }
    
    @IBOutlet var portfolioProfitLabel: BalanceLabel! {
        didSet {
            portfolioProfitLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var portfolioProfitTitleLabel: UILabel! {
        didSet {
            portfolioProfitTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    @IBOutlet var portfolioInvestedCurrencyLabel: CurrencyLabel! {
        didSet {
            portfolioInvestedCurrencyLabel.currencyType = .gvt
        }
    }
    
    @IBOutlet var portfolioInvestedLabel: BalanceLabel! {
        didSet {
            portfolioInvestedLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var portfolioInvestedTitleLabel: UILabel! {
        didSet {
            portfolioInvestedTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    @IBOutlet var portfolioValueCurrencyLabel: CurrencyLabel! {
        didSet {
            portfolioValueCurrencyLabel.currencyType = .usd
        }
    }
    
    @IBOutlet var portfolioValueLabel: BalanceLabel! {
        didSet {
            portfolioValueLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var portfolioValueTitleLabel: UILabel! {
        didSet {
            portfolioValueTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    @IBOutlet var portfolioInvestedTooltip: TooltipButton! {
        didSet {
            portfolioInvestedTooltip.tooltipText = String.Tooltitps.portfolioInvested
        }
    }
    
    @IBOutlet var portfolioProfitTooltip: TooltipButton! {
        didSet {
            portfolioProfitTooltip.tooltipText = String.Tooltitps.portfolioProfit
        }
    }
    
    @IBOutlet var portfolioValueTooltip: TooltipButton! {
        didSet {
            portfolioValueTooltip.tooltipText = String.Tooltitps.portfolioValue
        }
    }
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
}
