//
//  FilterAmountTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

struct AmountTitles {
    var title: String
    var subtitle: String
}

enum AmountType: Int {
    case level
    case totalProfit
    case averageProfit
}

struct FilterAmountTableViewCellViewModel {
    var minValue: Int?
    var maxValue: Int?
    
    var amountTitles: AmountTitles
    var amountType: AmountType
    
    var selectedMinValue: Int?
    var selectedMaxValue: Int?
    var sliderViewTag: Int
    
    weak var delegate: TTRangeSliderDelegate?
}

extension FilterAmountTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterAmountTableViewCell) {
        cell.titleLabel.text = amountTitles.title
        cell.subtitleLabel.text = amountTitles.subtitle
        cell.titleLabel.textColor = UIColor.Slider.title
        cell.subtitleLabel.textColor = UIColor.Slider.subTitle
        let min = minValue ?? 0
        let max = maxValue ?? 100
        cell.sliderView.minValue = Float(min)
        cell.sliderView.maxValue = Float(max)
        cell.sliderView.enableStep = sliderViewTag == 0
        cell.sliderView.step = 1
        cell.sliderView.selectedMinimum = Float(selectedMinValue ?? min)
        cell.sliderView.selectedMaximum = Float(selectedMaxValue ?? max)
        cell.sliderView.tag = sliderViewTag
        
        cell.sliderView.delegate = delegate
    }
}
