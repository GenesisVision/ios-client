//
//  WalletBalanceTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct WalletBalanceTableViewCellViewModel {
    let type: WalletBalanceType
    let grandTotal: WalletsGrandTotal?
    let selectedWallet: WalletData?
}

extension WalletBalanceTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletBalanceTableViewCell) {
        cell.selectionStyle = .none
        
        var balanceString = ""
        var percent: Double? = nil
        
        if let selectedWallet = selectedWallet, let walletCurrency = selectedWallet.currency, let currencyType = CurrencyType(rawValue: walletCurrency.rawValue) {
            switch type {
            case .total:
                if let balanceValue = selectedWallet.total {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                }
            case .available:
                if let totalBalanceValue = selectedWallet.total, let balanceValue = selectedWallet.available {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .invested:
                if let totalBalanceValue = selectedWallet.total, let balanceValue = selectedWallet.invested {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .trading:
                if let totalBalanceValue = selectedWallet.total, let balanceValue = selectedWallet.trading {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            }
        }
        
        if let grandTotal = grandTotal, let walletCurrency = grandTotal.currency, let currencyType = CurrencyType(rawValue: walletCurrency.rawValue) {
            switch type {
            case .total:
                if let balanceValue = grandTotal.total {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                }
            case .available:
                if let totalBalanceValue = grandTotal.total, let balanceValue = grandTotal.available {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .invested:
                if let totalBalanceValue = grandTotal.total, let balanceValue = grandTotal.invested {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .trading:
                if let totalBalanceValue = grandTotal.total, let balanceValue = grandTotal.trading {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            }
        }
        
        cell.configure(type, balance: balanceString, percent: percent)
    }
}

