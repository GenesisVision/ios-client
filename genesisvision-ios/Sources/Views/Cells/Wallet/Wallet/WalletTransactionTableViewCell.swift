//
//  WalletTransactionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTransactionTableViewCell: PlateTableViewCell {

    // MARK: - Labels
    @IBOutlet var investTypeLabel: UILabel! {
        didSet {
            investTypeLabel.textColor = UIColor.Transaction.investType
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = UIColor.Transaction.date
        }
    }
    
    @IBOutlet var amountLabel: UILabel! {
        didSet {
            amountLabel.textColor = UIColor.Transaction.greenTransaction
            amountLabel.font = UIFont.getFont(.bold, size: 20)
        }
    }
    
    @IBOutlet var programTitleLabel: UILabel! {
        didSet {
            programTitleLabel.textColor = UIColor.Transaction.programTitle
        }
    }
    
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
