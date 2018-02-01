//
//  FilterAmountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct FilterAmountTableViewCellViewModel {
    var minValue: Float
    var maxValue: Float
    var selectedMinimum: Float
    var selectedMaximum: Float
    var step: Float
}

extension FilterAmountTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterAmountTableViewCell) {
        cell.sliderView.minValue = minValue
        cell.sliderView.maxValue = maxValue
        cell.sliderView.selectedMinimum = selectedMinimum
        cell.sliderView.selectedMaximum = selectedMaximum
        cell.sliderView.step = step
    }
}
