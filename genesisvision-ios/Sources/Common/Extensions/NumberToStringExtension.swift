//
//  NumberToStringExtension.swift
//  genesisvision-ios
//
//  Created by George on 12/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Double {
    func getString(with currency: CurrencyType) -> String {
        return self.rounded(with: currency).toString() + " " + currency.rawValue
    }
    
    func toString(currency: Bool = false, withoutFormatter: Bool = false) -> String {
        guard !withoutFormatter else {
            return String(describing: self)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = currency ? .currency : .decimal
        
        numberFormatter.locale = Locale(identifier: "en_US")
        
        numberFormatter.maximumFractionDigits = 8
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number) ?? String(describing: self)
    }
    
    func getPercentageString() -> String {
        let percentText = self < 1.0 && self > 0.0 ? (self * 100.0).rounded(with: .undefined).toString() : "∞"
        return percentText + "%"
    }
    
}

extension Int {
    func toString(currency: Bool = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = currency ? .currency : .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number) ?? String(describing: self)
    }
}
