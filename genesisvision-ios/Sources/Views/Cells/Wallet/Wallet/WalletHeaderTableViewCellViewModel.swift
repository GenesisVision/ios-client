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
    let balance: Double
    let usdBalance: Double
    weak var delegate: WalletHeaderTableViewCellProtocol?
}

extension WalletHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletHeaderTableViewCell) {
        cell.balanceLabel.text = balance.rounded(withType: .gvt).toString()
        cell.usdBalanceLabel.text = usdBalance.rounded(withType: .usd).toString(currency: true)
        cell.delegate = delegate
    }
}

