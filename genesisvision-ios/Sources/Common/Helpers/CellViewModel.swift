//
//  CellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

// For non-generic cases
protocol CellViewAnyModel {
    static var cellAnyType: UIView.Type { get }
    func setupDefault(on cell: UIView)
}

// For generic one and models itselfs
protocol CellViewModel: CellViewAnyModel {
    associatedtype CellType: UIView
    func setup(on cell: CellType)
}

extension CellViewModel {
    static var cellAnyType: UIView.Type {
        return CellType.self
    }
    
    func setupDefault(on cell: UIView) {
        if let cell = cell as? CellType {
            setup(on: cell)
        } else {
            assertionFailure("Wrong usage")
        }
    }
}

