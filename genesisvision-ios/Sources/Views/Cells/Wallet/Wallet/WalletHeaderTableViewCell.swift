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
    func updateBalanceDidPress()
}

class WalletHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    weak var delegate: WalletHeaderTableViewCellProtocol?
    
    // MARK: - Views
    @IBOutlet var logoImageView: UIImageView!
    // MARK: - Labels
    @IBOutlet var balanceLabel: UILabel! {
        didSet {
            balanceLabel.textColor = UIColor.Header.darkTitle
        }
    }
    
    @IBOutlet var usdBalanceLabel: UILabel! {
        didSet {
            usdBalanceLabel.textColor = UIColor.Header.darkTitle.withAlphaComponent(0.7)
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var depositButton: ActionButton!
    @IBOutlet weak var withdrawButton: ActionButton!
    @IBOutlet weak var updateBalanceButton: UIButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Background.darkGray
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func depositButtonAction(_ sender: Any) {
        delegate?.depositProgramDidPress()
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        delegate?.withdrawProgramDidPress()
    }
    
    @IBAction func updateBalanceButtonAction(_ sender: Any) {
        delegate?.updateBalanceDidPress()
    }
}

