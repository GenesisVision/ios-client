//
//  ProgramPropertiesForTableViewCellView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramPropertiesForTableViewCellView: UIStackView {
    // MARK: - Outlets
    @IBOutlet var endOfPeriodLabel: UILabel! 
    @IBOutlet var periodDurationLabel: UILabel!
    @IBOutlet var periodDurationTitleLabel: UILabel! {
        didSet {
            periodDurationTitleLabel.text = "days"
        }
    }
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTimeLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    @IBOutlet var feeSuccessLabel: UILabel!
    @IBOutlet var feeManagementLabel: UILabel!
    
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var managersShareLabel: UILabel!
    
    // MARK: - Variables
    var endOfPeriod: Date?
    var isEnable: Bool = false {
        didSet {
            updatePeriodLeftValueLabel()
        }
    }
    
    var timer: Timer?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Public Methods
    func setup(with endOfPeriod: Date?, periodDuration: Int?, feeSuccess: Double?, feeManagement: Double?, trades: Int?, ownBalance: Double?, balance: Double?, isEnable: Bool, reloadDataProtocol: ReloadDataProtocol?) {
        guard let endOfPeriod = endOfPeriod,
            let periodDuration = periodDuration,
            let feeSuccess = feeSuccess,
            let feeManagement = feeManagement,
            let trades = trades,
            let ownBalance = ownBalance,
            let balance = balance else { return }
        
        self.endOfPeriod = endOfPeriod
        self.isEnable = isEnable
        self.reloadDataProtocol = reloadDataProtocol
        
        periodDurationLabel.text = periodDuration.toString()
        
        feeSuccessLabel.text = feeSuccess.rounded(toPlaces: 2).toString()
        feeManagementLabel.text = feeManagement.rounded(toPlaces: 2).toString()
        tradesLabel.text = trades.toString()
        let managersShare = (ownBalance / balance * 100).rounded(toPlaces: 2)
        managersShareLabel.text = managersShare.toString()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Lifecycle
    deinit {
        stopTimer()
    }
    
    // MARK: - Private methods
    private func updatePeriodLeftValueLabel() {
        periodLeftTimeLabel.isHidden = !isEnable
        
        timer?.invalidate()
        
        if isEnable {
            periodLeftValueLabel.numberOfLines = 1
            periodLeftValueLabel.font = UIFont.getFont(.bold, size: 20)
            
            updatePeriodLeftValue()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePeriodLeftValue), userInfo: nil, repeats: true)
        } else {
            programClosed()
        }
    }
    
    private func programClosed() {
        periodLeftValueLabel.numberOfLines = 3
        periodLeftValueLabel.font = UIFont.getFont(.bold, size: 15)
        
        periodLeftValueLabel.text = "\nProgram \nclosed"
        periodLeftTitleLabel.isHidden = true
    }
    
    @objc func updatePeriodLeftValue() {
        if let endOfPeriod = endOfPeriod {
            let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
            let periodLeftValue = periodLeft.0
            
            if periodLeftValue >= 0, let periodLeftTimeValue = periodLeft.1 {
                periodLeftValueLabel.text = periodLeftValue.toString()
                periodLeftTimeLabel.text = periodLeftTimeValue
            } else {
                reloadDataProtocol?.didReloadData()
            }
        }
    }
}

