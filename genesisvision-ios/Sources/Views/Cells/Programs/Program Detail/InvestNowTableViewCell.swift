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
}

class InvestNowTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet var investStackView: UIStackView!
    @IBOutlet var investValueLabel: UILabel! {
        didSet {
            investValueLabel.textColor = UIColor.Cell.title
            investValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var investTitleLabel: UILabel! {
        didSet {
            investTitleLabel.textColor = UIColor.Cell.subtitle
            investTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var entryFeeStackView: UIStackView!
    @IBOutlet var entryFeeValueLabel: UILabel! {
        didSet {
            entryFeeValueLabel.textColor = UIColor.Cell.title
            entryFeeValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var entryFeeTitleLabel: UILabel! {
        didSet {
            entryFeeTitleLabel.textColor = UIColor.Cell.subtitle
            entryFeeTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var successFeeStackView: UIStackView!
    @IBOutlet var successFeeValueLabel: UILabel! {
        didSet {
            successFeeValueLabel.textColor = UIColor.Cell.title
            successFeeValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var successFeeTitleLabel: UILabel! {
        didSet {
            successFeeTitleLabel.textColor = UIColor.Cell.subtitle
            successFeeTitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var investButton: ActionButton! {
        didSet {
            investButton.setEnabled(AuthManager.isLogin())
        }
    }
    
    @IBOutlet var disclaimerLabel: SubtitleLabel!
    
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
