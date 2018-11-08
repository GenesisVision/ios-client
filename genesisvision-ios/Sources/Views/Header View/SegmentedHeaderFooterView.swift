//
//  SegmentedHeaderFooterView.swift
//  genesisvision-ios
//
//  Created by George on 21/08/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SegmentedHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let buttonBar = UIView()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Public methods
    func configure(with segments: [String]) {
        segmentedControl.removeAllSegments()
        
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        let textAttributes = [NSAttributedStringKey.font: UIFont.getFont(.bold, size: SystemSizes.unselectedSegmentedTitle),
                              NSAttributedStringKey.foregroundColor: UIColor.Cell.subtitle]
        let textSelectAttributes = [NSAttributedStringKey.font: UIFont.getFont(.bold, size: SystemSizes.selectedSegmentedTitle),
                                    NSAttributedStringKey.foregroundColor: UIColor.Cell.title]
        
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .selected)
        
        
        for (idx, segment) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment, at: idx, animated: true)
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
}
