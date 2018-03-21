//
//  ProgramListHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramListHeaderTableViewCellViewModel {
    let programListCount: Int
}

extension ProgramListHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramListHeaderTableViewCell) {
        cell.programListCountLabel.text = programListCount.toString()
    }
}
