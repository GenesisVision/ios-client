//
//  FilterAmountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct FilterAmountTableViewCellViewModel {
    var minValue: Double
    var maxValue: Double
    var selectedMinimum: Double?
    var selectedMaximum: Double?
    var step: Float
}

extension FilterAmountTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterAmountTableViewCell) {
        cell.sliderView.minValue = Float(minValue)
        cell.sliderView.maxValue = Float(maxValue)
        cell.sliderView.selectedMinimum = Float(selectedMinimum ?? minValue)
        cell.sliderView.selectedMaximum = Float(selectedMaximum ?? maxValue)
        cell.sliderView.step = step
    }
}
