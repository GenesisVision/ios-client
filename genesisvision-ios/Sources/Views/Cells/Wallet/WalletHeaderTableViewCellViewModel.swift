//
//  WalletHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct WalletHeaderTableViewCellViewModel {
    let balance: Double
    let currency: String
}

extension WalletHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletHeaderTableViewCell) {
        cell.balanceLabel.text = String(describing: balance)
        cell.currencyLabel.text = currency
    }
}

