//
//  RoundingExtensions.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places: UInt) -> Double {
        let decimalValue = pow(10.0, Double(places))
        return (self * decimalValue).rounded() / decimalValue
    }
}
