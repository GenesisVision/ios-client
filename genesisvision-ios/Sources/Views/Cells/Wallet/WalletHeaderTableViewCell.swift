//
//  WalletHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Labels
    @IBOutlet var balanceLabel: UILabel! {
        didSet {
            balanceLabel.textColor = UIColor.Wallet.balance
        }
    }
    
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.textColor = UIColor.Wallet.currency
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

