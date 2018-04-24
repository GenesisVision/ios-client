//
//  ProgramDetailsForTableViewCellView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailsForTableViewCellView: UIStackView {

    // MARK: - Outlets
    @IBOutlet var investorsTooltip: TooltipButton! {
        didSet {
            investorsTooltip.tooltipText = String.Tooltitps.investors
        }
    }
    
    @IBOutlet var balanceTooltip: TooltipButton! {
        didSet {
            balanceTooltip.tooltipText = String.Tooltitps.balance
        }
    }
    @IBOutlet var avgProfitTooltip: TooltipButton! {
        didSet {
            avgProfitTooltip.tooltipText = String.Tooltitps.avgProfit
        }
    }
    
    @IBOutlet var totalProfitTooltip: TooltipButton! {
        didSet {
            totalProfitTooltip.tooltipText = String.Tooltitps.totalProfit
        }
    }
    
    @IBOutlet var investorsTitleLabel: UILabel!
    @IBOutlet var balanceTitleLabel: UILabel!
    @IBOutlet var avgProfitTitleLabel: UILabel!
    @IBOutlet var totalProfitTitleLabel: UILabel!
    
    @IBOutlet var balanceCurrencyLabel: CurrencyLabel!
    @IBOutlet var profitCurrencyLabel: CurrencyLabel!
    
    @IBOutlet var investorsValueLabel: UILabel!
    @IBOutlet var balanceValueLabel: BalanceLabel!
    @IBOutlet var avgProfitValueLabel: BalanceLabel!
    @IBOutlet var totalProfitValueLabel: BalanceLabel!
    
    // MARK: - Public Methods
    func setup(with investorsCountTitle: String? = "INVESTORS", investorsCount: Int?,
               balanceTitle: String? = "BALANCE", balance: Double?,
               avgProfitTitle: String? = "AVG. PROFIT", avgProfit: Double?,
               totalProfitTitle: String? = "TOTAL PROFIT", totalProfit: Double?,
               currency: String?) {
        investorsTitleLabel.text = investorsCountTitle
        balanceTitleLabel.text = balanceTitle
        avgProfitTitleLabel.text = avgProfitTitle
        totalProfitTitleLabel.text = totalProfitTitle
        
        investorsTitleLabel.textColor = UIColor.Font.darkBlue
        balanceTitleLabel.textColor = UIColor.Font.darkBlue
        avgProfitTitleLabel.textColor = UIColor.Font.darkBlue
        
        backgroundColor = UIColor.NavBar.background
        
        if let investorsCount = investorsCount,
            let balance = balance,
            let avgProfit = avgProfit,
            let totalProfit = totalProfit,
            let currency = currency {
            
            let avgProfitValue = avgProfit.rounded(withType: .other)
            let totalProfitValue = totalProfit.rounded(withType: .gvt)
            
            investorsValueLabel.text = investorsCount.toString()
            balanceValueLabel.amountValue = balance
            balanceValueLabel.shortView = true
            balanceValueLabel.currency = currency
            balanceValueLabel.shortView = true
            avgProfitValueLabel.text = avgProfitValue.toString() + "%"
            totalProfitValueLabel.amountValue = totalProfitValue
            
            investorsValueLabel.textColor = UIColor.Font.dark
            balanceValueLabel.textColor = UIColor.Font.dark
            avgProfitValueLabel.textColor = UIColor.Font.dark
            
            totalProfitValueLabel.textColor = totalProfit >= 0 ? UIColor.Font.dark : UIColor.Font.red
            totalProfitTitleLabel.text = totalProfit >= 0 ? "TOTAL PROFIT" : "LOSS"
            totalProfitTitleLabel.textColor = totalProfit >= 0 ? UIColor.Font.darkBlue : UIColor.Font.red
            
            balanceCurrencyLabel.text = currency
            profitCurrencyLabel.text = Constants.currency
        }
    }
}
