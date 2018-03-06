//
//  WalletFilterTypeTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct WalletFilterTypeTableViewCellViewModel {
    var selectedIndex: Int
    var types: [String]
    weak var delegate: WalletFilterTypeTableViewCellProtocol?
}

extension WalletFilterTypeTableViewCellViewModel: CellViewModel {
    func setup(on cell: WalletFilterTypeTableViewCell) {
        cell.segmentedControl.removeAllSegments()
        
        for (index, type) in types.enumerated() {
            cell.segmentedControl.insertSegment(withTitle: type, at: index, animated: false)
        }
        
        cell.segmentedControl.selectedSegmentIndex = selectedIndex
        cell.delegate = delegate
    }
}
