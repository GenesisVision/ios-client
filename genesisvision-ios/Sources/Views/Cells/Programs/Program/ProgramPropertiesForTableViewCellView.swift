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
    @IBOutlet var endOfPeriodDaysLabel: UILabel!
    @IBOutlet var periodDurationLabel: UILabel!
    
    @IBOutlet var feeSuccessLabel: UILabel!
    @IBOutlet var feeManagementLabel: UILabel!
    
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var availableInvestmentLabel: UILabel!
    
    // MARK: - Public Methods
    func setup(with endOfPeriod: Date?, periodDuration: Int?, feeSuccess: Double?, feeManagement: Double?, trades: Int?, availableInvestment: Double?) {
        guard let endOfPeriod = endOfPeriod,
            let periodDuration = periodDuration,
            let feeSuccess = feeSuccess,
            let feeManagement = feeManagement,
            let trades = trades,
            let availableInvestment = availableInvestment else { return }
            
        endOfPeriodLabel.text = endOfPeriod.defaultFormatString
        let dateInterval = endOfPeriod.interval(ofComponent: .day, fromDate: Date())
        endOfPeriodDaysLabel.text = String(describing: dateInterval)
        periodDurationLabel.text = String(describing: periodDuration)
        feeSuccessLabel.text = String(describing: Double(round(100 * feeSuccess) / 100))
        feeManagementLabel.text = String(describing: Double(round(100 * feeManagement) / 100))
        tradesLabel.text = String(describing: trades)
        availableInvestmentLabel.text = String(describing: Double(round(100 * availableInvestment) / 100))
        
        endOfPeriodLabel.textColor = UIColor.Font.primary
        endOfPeriodDaysLabel.textColor = UIColor.Font.primary
        periodDurationLabel.textColor = UIColor.Font.dark
        feeSuccessLabel.textColor = UIColor.Font.primary
        feeManagementLabel.textColor = UIColor.Font.primary
        tradesLabel.textColor = UIColor.Font.primary
        availableInvestmentLabel.textColor = UIColor.Font.primary
    }
}

