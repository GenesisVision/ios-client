//
//  RoundingExtensions.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Decimal {
    var count: Int {
        return max(-exponent, 0)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let decimalValue = pow(10.0, Double(places))
        return (self * decimalValue).rounded() / decimalValue
    }
    
    func rounded(withType type: CurrencyType) -> Double {
        return rounded(toPlaces: type.rawValue)
    }
    
    func rounded(withCurrency currencyValue: String?) -> Double {
        guard let currencyValue = currencyValue, let currency = InvestmentProgramDetails.Currency(rawValue: currencyValue) else {
            return rounded(withType: .other)
        }
        
        switch currency {
        case .usd, .eur:
            return rounded(withType: .other)
        case .eth, .btc:
            return rounded(withType: .crypto)
        case .gvt:
            return rounded(withType: .gvt)
        default:
            return rounded(withType: .other)
        }
    }
}
