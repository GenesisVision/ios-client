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
    let account: CopyTradingAccountInfo?
}

extension WalletBalanceTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletBalanceTableViewCell) {
        cell.selectionStyle = .none
        
        var balanceString = ""
        var percent: Double? = nil
        
        if let selectedWallet = account, let accountCurrency = selectedWallet.currency, let currencyType = CurrencyType(rawValue: accountCurrency.rawValue) {
            switch type {
            case .total:
                if let balanceValue = selectedWallet.balance {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                }
            case .available:
                if let totalBalanceValue = selectedWallet.balance, let balanceValue = selectedWallet.available {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            default:
                break
            }
        }
        
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
            case .pending:
                if let totalBalanceValue = selectedWallet.total, let balanceValue = selectedWallet.pending {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            }
        }
        
        if let grandTotal = grandTotal, let walletCurrency = grandTotal.currencyCcy, let currencyType = CurrencyType(rawValue: walletCurrency.rawValue) {
            switch type {
            case .total:
                if let balanceValue = grandTotal.totalCcy {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                }
            case .available:
                if let totalBalanceValue = grandTotal.totalCcy, let balanceValue = grandTotal.availableCcy {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .invested:
                if let totalBalanceValue = grandTotal.totalCcy, let balanceValue = grandTotal.investedCcy {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            case .pending:
                if let totalBalanceValue = grandTotal.totalCcy, let balanceValue = grandTotal.pendingCcy {
                    balanceString = balanceValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
                    percent = totalBalanceValue == 0.0 ? 0.0 : balanceValue / totalBalanceValue
                }
            }
        }
        
        cell.configure(type, balance: balanceString, percent: percent)
    }
}

