//
//  ReallocateHistoryTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

struct ReallocateHistoryTableViewCellViewModel {
    let model: ReallocationModel
}

extension ReallocateHistoryTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReallocateHistoryTableViewCell) {
        if let date = model.date {
            cell.dateLabel.text = date.dateAndTimeToString()
        }
    }
}


