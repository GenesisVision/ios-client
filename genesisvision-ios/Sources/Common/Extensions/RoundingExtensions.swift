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
        return rounded(toPlaces: type.currencyLenght)
    }
    
    func rounded(withCurrency currencyValue: String?) -> Double {
        guard let currencyValue = currencyValue, let currency = InvestmentProgramDetails.Currency(rawValue: currencyValue), let currencyType = CurrencyType(currency: currency) else {
            return rounded(withType: .usd)
        }
        
        return rounded(withType: currencyType)
    }
    
    func formatPoints() -> String {
        let thousandNum = self/1000
        let millionNum = self/1000000
        if self >= 1000 && self < 1000000 {
            if (floor(thousandNum) == thousandNum) {
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.rounded(toPlaces: 1))k")
        }
        if self > 1000000 {
            if (floor(millionNum) == millionNum) {
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.rounded(toPlaces: 1))M")
        } else {
            if (floor(self) == self) {
                return ("\(Int(self))")
            }
            return ("\(self)")
        }
    }
    
    var kmFormatted: String {
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fk", locale: Locale.current, self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fm", locale: Locale.current, self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current, self)
    }
}
