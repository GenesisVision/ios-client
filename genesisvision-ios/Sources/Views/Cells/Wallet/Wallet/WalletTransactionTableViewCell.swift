//
//  WalletTransactionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTransactionTableViewCell: PlateTableViewCell {

    // MARK: - Outlets
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var investTypeLabel: UILabel! {
        didSet {
            investTypeLabel.textColor = UIColor.Transaction.investType
        }
    }
    
    @IBOutlet var dateLabel: SubtitleLabel!
    @IBOutlet var amountLabel: SubtitleLabel! {
        didSet {
            amountLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet var programTitleLabel: TitleLabel!
    
    @IBOutlet var programStatusLabel: UILabel! {
        didSet {
            programStatusLabel.textColor = UIColor.Transaction.programStatus
        }
    }
    
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.textColor = UIColor.Transaction.currency
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
