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
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    @IBOutlet var feeSuccessLabel: UILabel!
    @IBOutlet var feeManagementLabel: UILabel!
    
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var investedTokensLabel: UILabel!
    
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
    func setup(with endOfPeriod: Date?, periodDuration: Int?, feeSuccess: Double?, feeManagement: Double?, trades: Int?, investedTokens: Double?, isEnable: Bool, reloadDataProtocol: ReloadDataProtocol?) {
        guard let endOfPeriod = endOfPeriod,
            let periodDuration = periodDuration,
            let feeSuccess = feeSuccess,
            let feeManagement = feeManagement,
            let trades = trades,
            let investedTokens = investedTokens else { return }
        
        self.endOfPeriod = endOfPeriod
        self.isEnable = isEnable
        self.reloadDataProtocol = reloadDataProtocol
        
        periodDurationLabel.text = periodDuration.toString()
        
        feeSuccessLabel.text = feeSuccess.rounded(toPlaces: 4).toString()
        feeManagementLabel.text = feeManagement.rounded(toPlaces: 4).toString()
        tradesLabel.text = trades.toString()
        investedTokensLabel.text = investedTokens.rounded(toPlaces: 4).toString()
    }
    
    // MARK: - Lifecycle
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private methods
    private func updatePeriodLeftValueLabel() {
        periodLeftTitleLabel.isHidden = !isEnable
        
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
        periodLeftValueLabel.numberOfLines = 2
        periodLeftValueLabel.font = UIFont.getFont(.bold, size: 15)
        
        periodLeftValueLabel.text = "Program \nclosed"
    }
    
    @objc func updatePeriodLeftValue() {
        if let endOfPeriod = endOfPeriod {
            let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
            let periodLeftValue = periodLeft.0
            
            if periodLeftValue >= 0, let periodLeftTimeValue = periodLeft.1 {
                periodLeftValueLabel.text = periodLeftValue.toString()
                periodLeftTitleLabel.text = periodLeftTimeValue
            } else {
                reloadDataProtocol?.didReloadData()
            }
        }
    }
}

