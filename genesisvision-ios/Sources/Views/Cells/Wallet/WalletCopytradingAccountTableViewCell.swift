//
//  WalletCopytradingAccountTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletCopytradingAccountTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.isHidden = true
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var balanceLabel: TitleLabel!
    @IBOutlet weak var equityLabel: SubtitleLabel!
    @IBOutlet weak var freeMarginLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
