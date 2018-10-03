//
//  WalletHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct WalletHeaderTableViewCellViewModel {
    let wallet: WalletSummary
}

extension WalletHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletHeaderTableViewCell) {
        cell.totalBalanceTitleLabel.text = "Total balance"
        if let totalBalanceGVT = wallet.totalBalanceGVT {
            cell.totalBalanceValueLabel.text = totalBalanceGVT.rounded(withType: .gvt).toString() + " GVT"
        }
        if let totalBalanceCurrency = wallet.totalBalanceCurrency {
            cell.totalBalanceCurrencyLabel.text = totalBalanceCurrency.toString() + " \(getSelectedCurrency())"
        }
        
        if let totalBalanceGVT = wallet.totalBalanceGVT, let availableGVT = wallet.availableGVT {
            let percent = availableGVT / totalBalanceGVT
            print(percent)
            //cell.availableProgressView
        }
        
        cell.availableTitleLabel.text = "Available"
        if let availableGVT = wallet.availableGVT {
            cell.availableValueLabel.text = availableGVT.rounded(withType: .gvt).toString() + " GVT"
        }
        if let availableCurrency = wallet.availableCurrency {
            cell.availableCurrencyLabel.text = availableCurrency.toString() + " \(getSelectedCurrency())"
        }
        
        if let totalBalanceGVT = wallet.totalBalanceGVT, let investedGVT = wallet.investedGVT {
            let percent = investedGVT / totalBalanceGVT
            print(percent)
//            cell.investedProgressView
        }
        cell.investedTitleLabel.text = "Invested value"
        if let investedGVT = wallet.investedGVT {
            cell.investedValueLabel.text = investedGVT.rounded(withType: .gvt).toString() + " GVT"
        }
        if let investedCurrency = wallet.investedCurrency {
            cell.investedCurrencyLabel.text = investedCurrency.toString() + " \(getSelectedCurrency())"
        }
    }
}

