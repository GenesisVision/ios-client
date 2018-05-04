//
//  FilterAmountTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

class FilterAmountTableViewCell: PlateTableViewCell {

    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.bold, size: 18)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14)
            subtitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    // MARK: - Views
    @IBOutlet var sliderView: TTRangeSlider!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
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
        
        sliderView.minLabelAccessibilityHint = "min"
        sliderView.minLabelAccessibilityLabel = "min"

        sliderView.maxLabelAccessibilityHint = "max"
        sliderView.maxLabelAccessibilityLabel = "max"
        
        selectionStyle = .none
    }
}
