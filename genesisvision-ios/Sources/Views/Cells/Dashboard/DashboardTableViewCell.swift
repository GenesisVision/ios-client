//
//  DashboardTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    var investmentProgramId: String = ""
    var investedTokens: Double = 0.0
    
    var endOfPeriod: Date?
    var isEnable: Bool = false {
        didSet {
            updatePeriodLeftValueLabel()
            contentView.backgroundColor = isEnable ? UIColor.Background.main : UIColor.Background.gray
            chartView.backgroundColor = isEnable ? UIColor.Background.main : UIColor.Background.gray
        }
    }
    
    var debugMode = isDebug
    
    var timer: Timer?
    var date = Date(timeIntervalSinceNow: Constants.TemplatesCounts.timerSeconds)
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var viewForChartView: UIView!
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
            chartView.backgroundColor = UIColor.Background.main
        }
    }
    
    @IBOutlet var inProcessIndicatorView: UIActivityIndicatorView! {
        didSet {
            inProcessIndicatorView.startAnimating()
            inProcessIndicatorView.color = UIColor.primary
            inProcessIndicatorView.isHidden = true
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var programTitleLabel: UILabel! 
    @IBOutlet var managerNameLabel: UILabel!
    
    @IBOutlet var tokenSymbolLabel: CurrencyLabel!
    
    @IBOutlet var tokensCountValueLabel: UILabel!
    @IBOutlet var tokensCountTitleLabel: UILabel!
    
    @IBOutlet var profitValueLabel: UILabel!
    @IBOutlet var profitTitleLabel: UILabel!
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    @IBOutlet var currencyLabel: CurrencyLabel!
    
    @IBOutlet var dashboardTooltip: TooltipButton! {
        didSet {
            dashboardTooltip.tooltipText = String.Tooltitps.dashboard
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Public methods
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
            periodLeftValueLabel.isHidden = false
            
            inProcessIndicatorView.isHidden = true
            inProcessIndicatorView.stopAnimating()
            
            periodLeftTitleLabel.numberOfLines = 1
            periodLeftTitleLabel.font = UIFont.getFont(.bold, size: 12)
        case .closed:
            periodLeftValueLabel.isHidden = true
            
            inProcessIndicatorView.isHidden = true
            inProcessIndicatorView.stopAnimating()
            
            periodLeftTitleLabel.numberOfLines = 2
            periodLeftTitleLabel.font = UIFont.getFont(.bold, size: 18)
        case .inProcess:
            periodLeftValueLabel.isHidden = true
            
            inProcessIndicatorView.isHidden = false
            inProcessIndicatorView.startAnimating()
            
            periodLeftTitleLabel.numberOfLines = 2
            periodLeftTitleLabel.font = UIFont.getFont(.bold, size: 12)
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
            self.periodLeftTitleLabel .text = "Program \nclosed"
        }
    }
    
    private func programInProcess() {
        DispatchQueue.main.async {
            self.periodUntilHide(.inProcess)
            self.periodLeftTitleLabel.text = "Calculating \nprofit..."
        }
    }
    
    @objc func updatePeriodLeftValue() {
        guard let endOfPeriod = endOfPeriod else { return stopTimer() }
        
        let periodLeft = getPeriodLeft(endOfPeriod: endOfPeriod)
        guard let periodLeftTitle = periodLeft.1 else { return stopTimer() }
        
        if periodLeft.0 > 0 && (periodLeft.0 < 2 && periodLeftTitle == "minutes" || periodLeftTitle == "seconds") {
            DispatchQueue.main.async {
                self.periodLeftValueLabel.text = periodLeft.0.toString()
                self.periodLeftTitleLabel.text = periodLeftTitle.uppercased() + " LEFT"
            }
        } else if periodLeft.0 == 0 {
            stopTimer()
            
            self.programInProcess()
        } else {
            self.periodLeftValueLabel.text = periodLeft.0.toString()
            self.periodLeftTitleLabel.text = periodLeftTitle.uppercased() + " LEFT"
        }
    }
}
