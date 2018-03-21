//
//  FilterSortTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct SortField {
    var type: String
    var text: String
}

struct FilterSortTableViewCellViewModel {
    var sorting: SortField
    var opened: Bool
}

extension FilterSortTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterSortTableViewCell) {
        cell.titleLabel.text = "Sort by " + sorting.text
        cell.titleLabel.addImage(image: #imageLiteral(resourceName: "img_dropdown_icon"), imageOffsetX: 10, afterLabel: true)
    }
}
