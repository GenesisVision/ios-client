//
//  ProgramDetailsForTableViewCellView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailsForTableViewCellView: UIStackView {

    @IBOutlet var investorsTitleLabel: UILabel!
    @IBOutlet var balanceTitleLabel: UILabel!
    @IBOutlet var avgProfitTitleLabel: UILabel!
    @IBOutlet var totalProfitTitleLabel: UILabel!
    
    @IBOutlet var investorsValueLabel: UILabel!
    @IBOutlet var balanceValueLabel: UILabel!
    @IBOutlet var avgProfitValueLabel: UILabel!
    @IBOutlet var totalProfitValueLabel: UILabel!
    
    // MARK: - Public Methods
    func setup(with investorsCountTitle: String? = "INVESTORS", investorsCount: Int?,
               balanceTitle: String? = "BALANCE", balance: Double?,
               avgProfitTitle: String? = "AVG. PROFIT", avgProfit: Double?,
               totalProfitTitle: String? = "TOTAL PROFIT", totalProfit: Double?) {
        investorsTitleLabel.text = investorsCountTitle
        balanceTitleLabel.text = balanceTitle
        avgProfitTitleLabel.text = avgProfitTitle
        totalProfitTitleLabel.text = totalProfitTitle
        
        investorsTitleLabel.textColor = UIColor.Font.darkBlue
        balanceTitleLabel.textColor = UIColor.Font.darkBlue
        avgProfitTitleLabel.textColor = UIColor.Font.darkBlue
        totalProfitTitleLabel.textColor = UIColor.Font.darkBlue
        
        backgroundColor = UIColor.NavBar.background
        
        if let investorsCount = investorsCount,
            let balance = balance,
            let avgProfit = avgProfit,
            let totalProfit = totalProfit {
            
            let avgProfitValue = avgProfit.rounded(toPlaces: 4)
            let totalProfitValue = totalProfit.rounded(toPlaces: 4)
            
            investorsValueLabel.text = investorsCount.toString()
            balanceValueLabel.text = balance.rounded(toPlaces: 4).toString()
            avgProfitValueLabel.text = avgProfitValue.toString() + "%"
            totalProfitValueLabel.text = totalProfitValue.toString()
            
            investorsValueLabel.textColor = UIColor.Font.dark
            balanceValueLabel.textColor = UIColor.Font.dark
            avgProfitValueLabel.textColor = UIColor.Font.dark
            totalProfitValueLabel.textColor = UIColor.Font.dark
        }
    }
}
