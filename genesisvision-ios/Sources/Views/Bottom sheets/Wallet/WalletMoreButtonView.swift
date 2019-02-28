//
//  WalletMoreButtonView.swift
//  genesisvision-ios
//
//  Created by George on 13/02/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletMoreButtonViewProtocol: class {
    func feeSwitchDidChange(value: Bool)
    func aboutFeesButtonDidTapped()
}

class WalletMoreButtonView: UIView {
    // MARK: - Variables
    weak var delegate: WalletMoreButtonViewProtocol?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var payFeesWithGvtSwitch: UISwitch! {
        didSet {
            payFeesWithGvtSwitch.onTintColor = UIColor.primary
            payFeesWithGvtSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            payFeesWithGvtSwitch.tintColor = UIColor.Cell.switchTint
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ wallet: WalletMultiSummary?) {
        guard let wallet = wallet, let payFeesWithGvt = wallet.payFeesWithGvt else { return }
        
        titleLabel.text = "Using GVT to pay for fees"
        payFeesWithGvtSwitch.isOn = payFeesWithGvt
    }
    
    // MARK: - Actions
    @IBAction func payFeesWithGvtSwitchAction(_ sender: UISwitch) {
        delegate?.feeSwitchDidChange(value: sender.isOn)
    }
    
    @IBAction func aboutFeesButtonAction(_ sender: UISwitch) {
        delegate?.aboutFeesButtonDidTapped()
    }
}
