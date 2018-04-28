//
//  ProgramPropertiesForTableViewCellView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum TimerState {
    case closed, opened, inProcess
}

protocol ProgramPropertiesForTableViewCellViewProtocol: class {
    func showTradesDidPressed()
}

class ProgramPropertiesForTableViewCellView: UIStackView {
    
    weak var delegate: ProgramPropertiesForTableViewCellViewProtocol?
    
    // MARK: - Outlets
    @IBOutlet var periodDurationTooltip: TooltipButton! {
        didSet {
            periodDurationTooltip.tooltipText = String.Tooltitps.periodDuration
        }
    }
    
    @IBOutlet var managersFundsShareTooltip: TooltipButton! {
        didSet {
            managersFundsShareTooltip.tooltipText = String.Tooltitps.managersFundsShare
        }
    }
    @IBOutlet var tradesTooltip: TooltipButton! {
        didSet {
            tradesTooltip.tooltipText = String.Tooltitps.trades
        }
    }
    
    @IBOutlet var successFeeTooltip: TooltipButton! {
        didSet {
            successFeeTooltip.tooltipText = String.Tooltitps.successFee
        }
    }
    @IBOutlet var managementFeeTooltip: TooltipButton! {
        didSet {
            managementFeeTooltip.tooltipText = String.Tooltitps.managementFee
        }
    }
    
    
    @IBOutlet var periodDurationLabel: UILabel!
    @IBOutlet var periodDurationTitleLabel: UILabel! {
        didSet {
            periodDurationTitleLabel.text = "days"
        }
    }
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTimeLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    @IBOutlet var untilPeriodImageView: UIImageView! {
        didSet {
            untilPeriodImageView.isHidden = false
        }
    }
    
    @IBOutlet var inProcessIndicatorView: UIActivityIndicatorView! {
        didSet {
            inProcessIndicatorView.startAnimating()
            inProcessIndicatorView.color = UIColor.primary
            inProcessIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet var feeSuccessLabel: UILabel!
    @IBOutlet var feeManagementLabel: UILabel!
    
    @IBOutlet var tradesStackView: UIStackView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTrades))
            tapGesture.numberOfTapsRequired = 1
            tradesStackView.isUserInteractionEnabled = true
            tradesStackView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var managersShareLabel: UILabel!
    
    // MARK: - Variables
    var endOfPeriod: Date?
    var isEnable: Bool = false {
        didSet {
            updatePeriodLeftValueLabel()
        }
    }
    
    var debugMode = isDebug
    
    var timer: Timer?

    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Lifecycle
    deinit {
        stopTimer()
    }

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
        
        feeSuccessLabel.text = feeSuccess.rounded(withType: .other).toString()
        feeManagementLabel.text = feeManagement.rounded(withType: .other).toString()
        tradesLabel.text = trades.toString()
        let managersShare = balance == 0 ? 0 : (ownBalance / balance * 100).rounded(withType: .other)
        managersShareLabel.text = managersShare.toString()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer() {
        guard let endOfPeriod = endOfPeriod else { return stopTimer() }
        
        let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
        if periodLeft.0 > 0 && (periodLeft.0 < 2 && periodLeft.1 == "minutes" || periodLeft.1 == "seconds") {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePeriodLeftValue), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    // MARK: - Private methods
    @objc private func showTrades() {
        delegate?.showTradesDidPressed()
    }
    
    private func updatePeriodLeftValueLabel() {
        stopTimer()
        
        if debugMode {
            endOfPeriod = Date(timeIntervalSinceNow: Constants.TemplatesCounts.timerSeconds)
        }
        
        guard isEnable else { return programClosed() }
        programOpened()
        updatePeriodLeftValue()
        startTimer()
    }
    
    private func periodUntilHide(_ state: TimerState) {
        switch state {
        case .opened:
            periodLeftTitleLabel.isHidden = false
            periodLeftTimeLabel.isHidden = false
            periodLeftValueLabel.isHidden = false
            untilPeriodImageView.isHidden = false
            
            inProcessIndicatorView.isHidden = true
            inProcessIndicatorView.stopAnimating()
            
            periodLeftTimeLabel.numberOfLines = 1
            periodLeftTimeLabel.font = UIFont.getFont(.bold, size: 20)
        case .closed:
            periodLeftTitleLabel.isHidden = true
            periodLeftValueLabel.isHidden = true
            untilPeriodImageView.isHidden = true
            
            inProcessIndicatorView.isHidden = true
            inProcessIndicatorView.stopAnimating()
            
            periodLeftTimeLabel.numberOfLines = 3
            periodLeftTimeLabel.font = UIFont.getFont(.bold, size: 20)
        case .inProcess:
            periodLeftTitleLabel.isHidden = true
            periodLeftValueLabel.isHidden = true
            untilPeriodImageView.isHidden = true
            
            inProcessIndicatorView.isHidden = false
            inProcessIndicatorView.startAnimating()
            
            periodLeftTimeLabel.numberOfLines = 3
            periodLeftTimeLabel.font = UIFont.getFont(.bold, size: 15)
        }
    }
    
    private func programOpened() {
        DispatchQueue.main.async {
            self.periodUntilHide(.opened)
        }
    }
    
    private func programClosed() {
        DispatchQueue.main.async {
            self.periodUntilHide(.closed)
            self.periodLeftTimeLabel.text = "\nProgram \nclosed"
        }
    }
        
    private func programInProcess() {
        DispatchQueue.main.async {
            self.periodUntilHide(.inProcess)
            self.periodLeftTimeLabel.text = "\nCalculating \nprofit..."
        }
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(reloadData), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadData() {
        reloadDataProtocol?.didReloadData()
        if debugMode {
            endOfPeriod = Date(timeIntervalSinceNow: Constants.TemplatesCounts.timerSeconds)
        }
    }
    
    @objc func updatePeriodLeftValue() {
        guard let endOfPeriod = endOfPeriod else { return stopTimer() }
        
        let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
        guard let periodLeftTimeValue = periodLeft.1 else { return stopTimer() }
        
        if periodLeft.0 > 0 && (periodLeft.0 < 2 && periodLeftTimeValue == "minutes" || periodLeftTimeValue == "seconds") {
            DispatchQueue.main.async {
                self.periodLeftValueLabel.text = periodLeft.0.toString()
                self.periodLeftTimeLabel.text = periodLeftTimeValue
            }
        } else if periodLeft.0 == 0 {
            stopTimer()
            
            self.programInProcess()
        } else {
            self.periodLeftValueLabel.text = periodLeft.0.toString()
            self.periodLeftTimeLabel.text = periodLeftTimeValue
        }
    }
}

