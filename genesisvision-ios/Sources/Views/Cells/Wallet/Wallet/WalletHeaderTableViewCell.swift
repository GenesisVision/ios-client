//
//  WalletHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletHeaderTableViewCellProtocol: class {
    func depositProgramDidPress()
    func withdrawProgramDidPress()
}

class WalletHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    weak var delegate: WalletHeaderTableViewCellProtocol?
    
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
    
    @IBOutlet var usdBalanceLabel: UILabel! {
        didSet {
            usdBalanceLabel.textColor = UIColor.Wallet.usdBalance
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func depositButtonAction(_ sender: Any) {
        delegate?.depositProgramDidPress()
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        delegate?.withdrawProgramDidPress()
    }
}

