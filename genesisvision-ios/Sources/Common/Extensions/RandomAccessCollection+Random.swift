//
//  RandomAccessCollection+Random.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension RandomAccessCollection {
    var rand: Iterator.Element? {
        guard count > 0 else { return nil }
        let offset = arc4random_uniform(numericCast(count))
        return self[index(startIndex, offsetBy: numericCast(offset))]
    }
}
