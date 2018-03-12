//
//  ProgramPropertiesForTableViewCellView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramPropertiesForTableViewCellView: UIStackView {
    
    @IBOutlet var endOfPeriodLabel: UILabel!
    @IBOutlet var periodDurationLabel: UILabel!
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    @IBOutlet var feeSuccessLabel: UILabel!
    @IBOutlet var feeManagementLabel: UILabel!
    
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var investedTokensLabel: UILabel!
    
    // MARK: - Public Methods
    func setup(with endOfPeriod: Date?, periodDuration: Int?, feeSuccess: Double?, feeManagement: Double?, trades: Int?, investedTokens: Double?) {
        guard let endOfPeriod = endOfPeriod,
            let periodDuration = periodDuration,
            let feeSuccess = feeSuccess,
            let feeManagement = feeManagement,
            let trades = trades,
            let investedTokens = investedTokens else { return }
            
        endOfPeriodLabel.text = endOfPeriod.defaultFormatString
        let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
        periodLeftValueLabel.text = periodLeft.0
        periodLeftTitleLabel.text = periodLeft.1
        periodDurationLabel.text = periodDuration.toString()
        
        feeSuccessLabel.text = feeSuccess.rounded(toPlaces: 4).toString()
        feeManagementLabel.text = feeManagement.rounded(toPlaces: 4).toString()
        tradesLabel.text = trades.toString()
        investedTokensLabel.text = investedTokens.rounded(toPlaces: 4).toString()
        
        endOfPeriodLabel.textColor = UIColor.Font.primary
        periodLeftValueLabel.textColor = UIColor.Font.primary
        periodDurationLabel.textColor = UIColor.Font.dark
        feeSuccessLabel.textColor = UIColor.Font.primary
        feeManagementLabel.textColor = UIColor.Font.primary
        tradesLabel.textColor = UIColor.Font.primary
        investedTokensLabel.textColor = UIColor.Font.primary
    }
}

