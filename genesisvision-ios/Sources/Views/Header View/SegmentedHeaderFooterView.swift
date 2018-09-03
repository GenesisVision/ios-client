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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Public methods
    func configure(with segments: [String]) {
        segmentedControl.removeAllSegments()
        
        for (idx, segment) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment, at: idx, animated: true)
        }
    }
}
