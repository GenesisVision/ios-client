//
//  FilterAmountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

struct FilterAmountTableViewCellViewModel {
    var minValue: Double
    var maxValue: Double
    var selectedMaxAmountFrom: Double?
    var selectedMaxAmountTo: Double?
    var step: Float
    weak var delegate: TTRangeSliderDelegate?
}

extension FilterAmountTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterAmountTableViewCell) {
        cell.sliderView.minValue = Float(minValue)
        cell.sliderView.maxValue = Float(maxValue)
        cell.sliderView.selectedMinimum = Float(selectedMaxAmountFrom ?? minValue)
        cell.sliderView.selectedMaximum = Float(selectedMaxAmountTo ?? maxValue)
        cell.sliderView.step = step
        cell.sliderView.delegate = delegate
    }
}
