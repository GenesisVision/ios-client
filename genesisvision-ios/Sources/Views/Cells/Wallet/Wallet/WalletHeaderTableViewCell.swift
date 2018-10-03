//
//  WalletHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit


class WalletHeaderTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var totalBalanceTitleLabel: SubtitleLabel!
    @IBOutlet weak var totalBalanceValueLabel: TitleLabel! {
        didSet {
            totalBalanceValueLabel.font = UIFont.getFont(.semibold, size: 26.0)
        }
    }
    @IBOutlet weak var totalBalanceCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var availableProgressView: UIView!
    @IBOutlet weak var availableTitleLabel: SubtitleLabel!
    @IBOutlet weak var availableValueLabel: TitleLabel!
    @IBOutlet weak var availableCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var investedProgressView: UIView!
    @IBOutlet weak var investedTitleLabel: SubtitleLabel!
    @IBOutlet weak var investedValueLabel: TitleLabel!
    @IBOutlet weak var investedCurrencyLabel: MediumLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}

