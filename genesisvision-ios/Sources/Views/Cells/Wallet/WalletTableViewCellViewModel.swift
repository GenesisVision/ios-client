//
//  WalletTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletTableViewCellViewModel {
    let wallet: WalletData
    let totalAmountInPlatformCurrency: Double?
}

extension WalletTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletTableViewCell) {
        cell.iconImageView.image = UIImage.walletPlaceholder
        
        if let logo = wallet.logoUrl, let logoUrl = URL(string: logo) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: logoUrl, placeholder: UIImage.programPlaceholder)
            cell.iconImageView.backgroundColor = .clear
        } else {
            cell.iconImageView.isHidden = true
        }
        
        if let title = wallet.title {
            cell.titleLabel.text = title
        } else {
            cell.titleLabel.text = ""
        }
        
        if let amount = wallet.available, let currency = wallet.currency {
            if let currency = CurrencyType(rawValue: currency.rawValue) {
                cell.amountLabel.text = amount.rounded(with: currency).toString() + " " + currency.rawValue
            }
        } else {
            cell.amountLabel.text = ""
        }
        
        if let amount = totalAmountInPlatformCurrency {
            let currency = getPlatformCurrencyType()
            cell.amountCcyLabel.text = amount.rounded(with: currency).toString() + " " + currency.rawValue
        } else {
            cell.amountCcyLabel.text = ""
        }
        
        cell.selectionStyle = .none
    }
}

