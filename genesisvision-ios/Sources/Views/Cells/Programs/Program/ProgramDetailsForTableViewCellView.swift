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
    @IBOutlet var programDetailsTooltip: TooltipButton! {
        didSet {
            programDetailsTooltip.tooltipText = String.Tooltitps.programDetails
        }
    }
    
    @IBOutlet var investorsTitleLabel: UILabel! {
        didSet {
            investorsTitleLabel.textColor = UIColor.Cell.subtitle
            investorsTitleLabel.font = UIFont.getFont(.light, size: 13.0)
        }
    }
    @IBOutlet var balanceTitleLabel: UILabel! {
        didSet {
            balanceTitleLabel.textColor = UIColor.Cell.subtitle
            balanceTitleLabel.font = UIFont.getFont(.light, size: 13.0)
        }
    }
    @IBOutlet var avgProfitTitleLabel: UILabel! {
        didSet {
            avgProfitTitleLabel.textColor = UIColor.Cell.subtitle
            avgProfitTitleLabel.font = UIFont.getFont(.light, size: 13.0)
        }
    }
    @IBOutlet var totalProfitTitleLabel: UILabel! {
        didSet {
            totalProfitTitleLabel.textColor = UIColor.Cell.subtitle
            totalProfitTitleLabel.font = UIFont.getFont(.light, size: 13.0)
        }
    }
    
    @IBOutlet var balanceCurrencyLabel: CurrencyLabel!
    @IBOutlet var profitCurrencyLabel: CurrencyLabel!
    @IBOutlet var investorsValueLabel: UILabel! {
        didSet {
            investorsValueLabel.textColor = UIColor.Cell.title
            investorsValueLabel.font = UIFont.getFont(.bold, size: 17.0)
        }
    }
    @IBOutlet var balanceValueLabel: BalanceLabel! {
        didSet {
            balanceValueLabel.textColor = UIColor.Cell.title
            balanceValueLabel.font = UIFont.getFont(.bold, size: 17.0)
        }
    }
    @IBOutlet var avgProfitValueLabel: BalanceLabel! {
        didSet {
            avgProfitValueLabel.textColor = UIColor.Cell.title
            avgProfitValueLabel.font = UIFont.getFont(.bold, size: 17.0)
        }
    }
    @IBOutlet var totalProfitValueLabel: BalanceLabel! {
        didSet {
            totalProfitValueLabel.textColor = UIColor.Cell.title
            totalProfitValueLabel.font = UIFont.getFont(.bold, size: 17.0)
        }
    }
    
    // MARK: - Public Methods
    func setup(with investorsCountTitle: String? = "INVESTORS", investorsCount: Int?,
               balanceTitle: String? = "BALANCE", balance: Double?,
               avgProfitTitle: String? = "AVG. PROFIT", avgProfit: Double?,
               totalProfitTitle: String? = "TOTAL PROFIT", totalProfit: Double?,
               currency: String?) {
//        investorsTitleLabel.text = investorsCountTitle
        balanceTitleLabel.text = balanceTitle
        avgProfitTitleLabel.text = avgProfitTitle
        totalProfitTitleLabel.text = totalProfitTitle

        backgroundColor = .clear

        if let investorsCount = investorsCount,
            let balance = balance,
            let avgProfit = avgProfit,
            let totalProfit = totalProfit,
            let currency = currency {

            let avgProfitValue = avgProfit.rounded(withType: .percent)
            let totalProfitValue = totalProfit.rounded(withType: .gvt)

//            investorsValueLabel.text = investorsCount.toString()
            balanceValueLabel.amountValue = balance
            balanceValueLabel.shortView = true
            balanceValueLabel.currency = currency
            balanceValueLabel.shortView = true
            avgProfitValueLabel.text = avgProfitValue.toString() + "%"
            totalProfitValueLabel.amountValue = totalProfitValue


            totalProfitValueLabel.textColor = totalProfit >= 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle

//            balanceCurrencyLabel.text = currency
//            if let currencyType = CurrencyType(currency: currency) {
//                balanceCurrencyLabel.currencyType = currencyType
//            }

//            profitCurrencyLabel.text = Constants.currency
//            if let currencyType = CurrencyType(currency: Constants.currency) {
//                profitCurrencyLabel.currencyType = currencyType
//            }
        }
    }
}
