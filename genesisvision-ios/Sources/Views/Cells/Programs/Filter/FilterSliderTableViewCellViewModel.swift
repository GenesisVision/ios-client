//
//  FilterAmountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

struct FilterTitles {
    var title: String
    var subtitle: String
}

struct FilterSliderTableViewCellViewModel {
    var minValue: Double
    var maxValue: Double
    
    var filterTitles: FilterTitles
    var amountType: SliderType
    
    var selectedMinValue: Double?
    var selectedMaxValue: Double?
    
    var customFormatter: NumberFormatter?
    
    var sliderViewTag: Int
    
    weak var delegate: TTRangeSliderDelegate?
}

extension FilterSliderTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterAmountTableViewCell) {
        cell.titleLabel.text = filterTitles.title
        cell.subtitleLabel.text = filterTitles.subtitle
        
        let min = minValue
        let max = maxValue
        cell.sliderView.minValue = Float(min)
        cell.sliderView.maxValue = Float(max)
        cell.sliderView.enableStep = sliderViewTag == 0
        cell.sliderView.step = 1
        cell.sliderView.selectedMinimum = Float(selectedMinValue ?? min)
        cell.sliderView.selectedMaximum = Float(selectedMaxValue ?? max)
        cell.sliderView.tag = sliderViewTag
        
        if let customFormatter = customFormatter {
            cell.sliderView.numberFormatterOverride = customFormatter
        }
        
        cell.sliderView.delegate = delegate
    }
}
