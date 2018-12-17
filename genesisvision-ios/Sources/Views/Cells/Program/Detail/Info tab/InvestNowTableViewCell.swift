//
//  InvestNowTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol InvestNowProtocol: class {
    func didTapInvestButton()
    func didTapEntryFeeTooltipButton(_ tooltipText: String)
}

class InvestNowTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet var investStackView: UIStackView!
    @IBOutlet var investValueLabel: TitleLabel!
    @IBOutlet var investTitleLabel: SubtitleLabel!
    
    @IBOutlet var entryFeeStackView: UIStackView!
    @IBOutlet var entryFeeValueLabel: TitleLabel!
    @IBOutlet var entryFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet var successFeeStackView: UIStackView!
    @IBOutlet var successFeeValueLabel: TitleLabel!
    @IBOutlet var successFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet var investButton: ActionButton! {
        didSet {
            investButton.setEnabled(AuthManager.isLogin())
        }
    }
    
    @IBOutlet var entryFeeTooltip: TooltipButton! {
        didSet {
            entryFeeTooltip.tooltipText = String.Tooltitps.entryFee
            entryFeeTooltip.delegate = self
            entryFeeTooltip.isHidden = true
        }
    }
    
    @IBOutlet var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .center
        }
    }
    
    weak var investNowProtocol: InvestNowProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: UIButton) {
        investNowProtocol?.didTapInvestButton()
    }
}

extension InvestNowTableViewCell: TooltipButtonProtocol {
    func showDidPress(_ tooltipText: String) {
        investNowProtocol?.didTapEntryFeeTooltipButton(tooltipText)
    }
}
