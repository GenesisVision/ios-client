//
//  FilterSwitchTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 26/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct FilterSwitchTableViewCellViewModel {
    var filterTitles: FilterTitles
    var isOn: Bool?
    var switchViewTag: Int
    weak var delegate: FilterSwitchTableViewCellProtocol?
}

extension FilterSwitchTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterSwitchTableViewCell) {
        cell.titleLabel.text = filterTitles.title
        cell.subtitleLabel.text = filterTitles.subtitle
        cell.titleLabel.textColor = UIColor.Slider.title
        cell.subtitleLabel.textColor = UIColor.Slider.subTitle
        
        cell.switchControl.isOn = isOn ?? false
        
        cell.switchControl.tag = switchViewTag
        
        cell.delegate = delegate
    }
}
