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
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var statusButton: StatusButton!
    
    @IBOutlet weak var investedTitleLabel: SubtitleLabel!
    @IBOutlet weak var investedValueLabel: TitleLabel!
    
    @IBOutlet weak var valueTitleLabel: SubtitleLabel!
    @IBOutlet weak var valueLabel: TitleLabel!
    
    @IBOutlet weak var profitTitleLabel: SubtitleLabel!
    @IBOutlet weak var profitValueLabel: TitleLabel!
    
    @IBOutlet weak var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.configure(with: .darkClear)
            withdrawButton.setEnabled(AuthManager.isLogin())
        }
    }
    
    @IBOutlet weak var reinvestView: UIView! 
    @IBOutlet weak var reinvestTitleLabel: TitleLabel!
    
    @IBOutlet weak var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = String.Tooltitps.reinvest
            reinvestTooltip.isHidden = true
        }
    }
    
    @IBOutlet weak var reinvestSwitch: UISwitch! {
        didSet {
            reinvestSwitch.onTintColor = UIColor.primary
            reinvestSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            reinvestSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
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
        yourInvestmentProtocol?.didChangeSwitch(value: sender.isOn)
    }
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        yourInvestmentProtocol?.didTapStatusButton()
    }
}
