//
//  FilterAmountTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

class FilterAmountTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var sliderView: TTRangeSlider!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.background
        selectionStyle = .none
    }
}
