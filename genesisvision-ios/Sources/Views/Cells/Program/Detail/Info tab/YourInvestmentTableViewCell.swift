//
//  YourInvestmentTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class YourInvestmentTableViewCell: UITableViewCell {
    // MARK: - Variables
    weak var yourInvestmentProtocol: YourInvestmentProtocol?

    // MARK: - Outlets
    @IBOutlet var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet var statusButton: StatusButton!
    
    @IBOutlet var investedTitleLabel: SubtitleLabel!
    @IBOutlet var investedValueLabel: TitleLabel!
    
    @IBOutlet var valueTitleLabel: SubtitleLabel!
    @IBOutlet var valueLabel: TitleLabel!
    
    @IBOutlet var profitTitleLabel: SubtitleLabel!
    @IBOutlet var profitValueLabel: TitleLabel!
    
    @IBOutlet var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.configure(with: .darkClear)
            withdrawButton.setEnabled(AuthManager.isLogin())
        }
    }
    
    @IBOutlet var reinvestView: UIView! 
    @IBOutlet var reinvestTitleLabel: TitleLabel!
    
    @IBOutlet var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = String.Tooltitps.reinvest
            reinvestTooltip.isHidden = true
        }
    }
    
    @IBOutlet var reinvestSwitch: UISwitch! {
        didSet {
            reinvestSwitch.onTintColor = UIColor.primary
            reinvestSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            reinvestSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    
    @IBOutlet var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .center
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        yourInvestmentProtocol?.didTapWithdrawButton()
    }
    
    @IBAction func reinvestSwitchAction(_ sender: UISwitch) {
        yourInvestmentProtocol?.didChangeReinvestSwitch(value: sender.isOn)
    }
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        yourInvestmentProtocol?.didTapStatusButton()
    }
}
