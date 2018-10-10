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
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    @IBOutlet var titleLabel: TitleLabel!
    @IBOutlet var amountLabel: TitleLabel!
    @IBOutlet var dateLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.BaseView.bg
    }
}
