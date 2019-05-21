//
//  WalletCopytradingAccountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletCopytradingAccountTableViewCellViewModel {
    let copyTradingAccountInfo: CopyTradingAccountInfo
}

extension WalletCopytradingAccountTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletCopytradingAccountTableViewCell) {
        cell.iconImageView.image = UIImage.walletPlaceholder
        
        if let logo = copyTradingAccountInfo.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.iconImageView.backgroundColor = .clear
        } else {
            cell.iconImageView.isHidden = true
        }
        
        if let title = copyTradingAccountInfo.title {
            cell.titleLabel.text = title
        } else {
            cell.titleLabel.text = ""
        }
        
        if let amount = copyTradingAccountInfo.balance, let currency = copyTradingAccountInfo.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            cell.balanceLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            cell.balanceLabel.textColor = amount == 0 ? UIColor.Cell.title : amount > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        } else {
            cell.balanceLabel.isHidden = true
        }
        
        if let equity = copyTradingAccountInfo.equity {
            cell.equityLabel.text = equity.rounded(withType: .undefined).toString()
        } else {
            cell.equityLabel.isHidden = true
        }
        
        if let freeMargin = copyTradingAccountInfo.freeMargin {
            cell.freeMarginLabel.text = freeMargin.rounded(withType: .undefined).toString()
        } else {
            cell.freeMarginLabel.isHidden = true
        }
        
        cell.selectionStyle = .none
    }
}

