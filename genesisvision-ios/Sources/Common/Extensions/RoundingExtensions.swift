//
//  RoundingExtensions.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum RoundedType {
    case gvt, crypto, other
}

extension Double {
    func rounded(toPlaces places: UInt) -> Double {
        let decimalValue = pow(10.0, Double(places))
        return (self * decimalValue).rounded() / decimalValue
    }
    
    func rounded(withType type: RoundedType) -> Double {
        switch type {
        case .gvt:
            return rounded(toPlaces: 4)
        case .crypto:
            return rounded(toPlaces: 8)
        default:
            return rounded(toPlaces: 2)
        }
    }
    
    func rounded(withCurrency currency: String?) -> Double {
        guard let currency = currency, let currencyType = InvestmentProgramDetails.Currency(rawValue: currency) else {
            return rounded(withType: .other)
        }
        
        switch currencyType {
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
