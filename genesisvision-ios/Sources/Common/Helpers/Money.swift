//
//  Money.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum Currency: String {
    case gvt, btc, eth
}

struct Money {
    let amount: NSDecimalNumber
    let currency: Currency
}
