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

    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.bold, size: 18)
        }
    }
    
    @IBOutlet var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14)
        }
    }
    
    // MARK: - Views
    @IBOutlet var sliderView: TTRangeSlider!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        sliderView.tintColorBetweenHandles = UIColor.Slider.primary
        sliderView.handleColor = UIColor.Slider.primary
        sliderView.tintColor = UIColor.Slider.line
        sliderView.handleBorderColor = UIColor.red
        sliderView.maxLabelColour = UIColor.Slider.label
        sliderView.minLabelColour = UIColor.Slider.label
        sliderView.minLabelFont = UIFont.getFont(.regular, size: 14)
        sliderView.maxLabelFont = UIFont.getFont(.regular, size: 14)
        sliderView.lineHeight = 5.0
        sliderView.handleDiameter = 13.0
        
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
}
