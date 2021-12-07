//
//  InvestNowTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol InvestNowProtocol: AnyObject {
    func didTapInvestButton()
    func didTapEntryFeeTooltipButton(_ tooltipText: String)
    func ditTapEditButton()
}



class InvestNowTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    
    @IBOutlet weak var investStackView: UIStackView!
    @IBOutlet weak var investValueLabel: TitleLabel!
    @IBOutlet weak var investTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var stopOutStackView: UIStackView!
    @IBOutlet weak var stopOutValueLabel: TitleLabel!
    @IBOutlet weak var stopOutTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var entryFeeStackView: UIStackView!
    @IBOutlet weak var entryFeeValueLabel: TitleLabel!
    @IBOutlet weak var entryFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var successFeeStackView: UIStackView!
    @IBOutlet weak var successFeeValueLabel: TitleLabel!
    @IBOutlet weak var successFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var investButton: ActionButton!
    @IBOutlet weak var editButton: ActionButton! {
        didSet {
            editButton.configure(with: .custom(options: ActionButtonOptions(borderWidth: 0, borderColor: nil, fontSize: 16, bgColor: .clear, textColor: UIColor.primary, image: nil, rightPosition: true)))
        }
    }
    
    @IBOutlet weak var entryFeeTooltip: TooltipButton! {
        didSet {
            entryFeeTooltip.tooltipText = String.Tooltitps.managementFee
            entryFeeTooltip.delegate = self
            entryFeeTooltip.isHidden = true
        }
    }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
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
    
    @IBAction func editButtonAction(_ sender: Any) {
        investNowProtocol?.ditTapEditButton()
    }
}

extension InvestNowTableViewCell: TooltipButtonProtocol {
    func showDidPress(_ tooltipText: String) {
        investNowProtocol?.didTapEntryFeeTooltipButton(tooltipText)
    }
}
