//
//  ProgramYourInvestmentTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ProgramYourInvestmentProtocol: class {
    func didTapWithdrawButton()
    func didChangeReinvestSwitch(value: Bool)
    func didTapStatusButton()
}

class ProgramYourInvestmentTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet var statusButton: StatusButton!
    
    @IBOutlet var investedValueLabel: UILabel! {
        didSet {
            investedValueLabel.textColor = UIColor.Cell.title
            investedValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var valueLabel: UILabel! {
        didSet {
            valueLabel.textColor = UIColor.Cell.title
            valueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var profitValueLabel: UILabel! {
        didSet {
            profitValueLabel.textColor = UIColor.Cell.greenTitle
            profitValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var investedTitleLabel: UILabel! {
        didSet {
            investedTitleLabel.textColor = UIColor.Cell.subtitle
            investedTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet var valueTitleLabel: UILabel! {
        didSet {
            valueTitleLabel.textColor = UIColor.Cell.subtitle
            valueTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet var profitTitleLabel: UILabel! {
        didSet {
            profitTitleLabel.textColor = UIColor.Cell.subtitle
            profitTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.configure(with: .darkClear)
            withdrawButton.setEnabled(AuthManager.isLogin())
        }
    }
    
    @IBOutlet var reinvestTitleLabel: UILabel! {
        didSet {
            reinvestTitleLabel.textColor = UIColor.Cell.title
            reinvestTitleLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = String.Tooltitps.reinvest
            reinvestTooltip.isHidden = true
        }
    }
    
    @IBOutlet var reinvestSwitch: UISwitch!
    
    @IBOutlet var disclaimerLabel: SubtitleLabel!
    
    weak var programYourInvestmentProtocol: ProgramYourInvestmentProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        programYourInvestmentProtocol?.didTapWithdrawButton()
    }
    
    @IBAction func reinvestSwitchAction(_ sender: UISwitch) {
        programYourInvestmentProtocol?.didChangeReinvestSwitch(value: sender.isOn)
    }
    
    @IBAction func statusButtonAction(_ sender: UISwitch) {
        programYourInvestmentProtocol?.didTapStatusButton()
    }
}
