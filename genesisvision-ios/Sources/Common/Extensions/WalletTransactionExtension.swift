//
//  WalletTransactionExtension.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension WalletTransaction.ModelType: EnumCollection {}

extension WalletTransaction {
    static var templateModel: WalletTransaction {
        
        let types = WalletTransaction.ModelType.allValues
        let idx = Int(arc4random_uniform(numericCast(types.count)))
        let amount = Double(arc4random_uniform(40000)) - 20000
        let type = types[idx]

        return WalletTransaction(id: nil, type: type, amount: amount, date: Date())
    }
}
