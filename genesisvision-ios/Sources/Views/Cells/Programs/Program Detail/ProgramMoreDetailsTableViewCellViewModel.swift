//
//  ProgramMoreDetailsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramMoreDetailsTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull
    weak var reloadDataProtocol: ReloadDataProtocol?
}

extension ProgramMoreDetailsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramMoreDetailsTableViewCell) {

    }
}
