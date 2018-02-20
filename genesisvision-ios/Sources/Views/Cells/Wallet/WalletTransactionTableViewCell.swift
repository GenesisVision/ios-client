//
//  WalletTransactionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTransactionTableViewCell: UITableViewCell {

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
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
}
