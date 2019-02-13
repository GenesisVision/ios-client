//
//  WalletTransactionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTransactionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var statusLabel: SubtitleLabel!
    @IBOutlet weak var amountLabel: TitleLabel!
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
