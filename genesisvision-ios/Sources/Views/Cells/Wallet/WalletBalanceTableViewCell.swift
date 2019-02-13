//
//  WalletBalanceTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletBalanceTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var balanceTitleLabel: SubtitleLabel!
    @IBOutlet weak var balanceValueLabel: TitleLabel! {
        didSet {
            balanceValueLabel.font = UIFont.getFont(.semibold, size: 26.0)
        }
    }
    
    @IBOutlet weak var progressView: CircularProgressView! {
        didSet {
            progressView.percentTextEnable = true
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    
    func configure(_ type: WalletBalanceType, balance: String, percent: Double? = nil, animated: Bool = true) {
        stackView.alignment = .center
        progressView.isHidden = true
        balanceTitleLabel.text = type.rawValue
        balanceValueLabel.text = balance
        
        if let percent = percent {
            stackView.alignment = .leading
            progressView.isHidden = false
            progressView.setProgress(to: percent, withAnimation: animated)
        }
        
        switch type {
        case .total:
            break
        case .available:
            progressView.foregroundStrokeColor = UIColor.Common.purple
            progressView.backgroundStrokeColor = UIColor.Common.purple.withAlphaComponent(0.2)
        case .invested:
            progressView.foregroundStrokeColor = UIColor.primary
            progressView.backgroundStrokeColor = UIColor.primary.withAlphaComponent(0.2)
        case .pending:
            progressView.foregroundStrokeColor = UIColor.Common.btcColor
            progressView.backgroundStrokeColor = UIColor.Common.btcColor.withAlphaComponent(0.2)
        }
    }
}
