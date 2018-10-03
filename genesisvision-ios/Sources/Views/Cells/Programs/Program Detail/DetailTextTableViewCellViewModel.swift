//
//  DetailTextTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct DetailTextTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull
}

extension DetailTextTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailTextTableViewCell) {
        cell.availableToInvestLabel.text = programDetailsFull.availableInvestment?.rounded(withType: .gvt).toString()
    }
}
