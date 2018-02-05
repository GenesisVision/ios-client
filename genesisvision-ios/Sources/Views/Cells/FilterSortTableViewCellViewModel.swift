//
//  FilterSortTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct FilterSortTableViewCellViewModel {
    var sorting: [String]
}

extension FilterSortTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterSortTableViewCell) {
        cell.textLabel?.text = sorting[0]
    }
}