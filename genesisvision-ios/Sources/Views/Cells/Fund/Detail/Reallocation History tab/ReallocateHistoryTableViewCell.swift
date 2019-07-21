//
//  ReallocateHistoryTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class ReallocateHistoryTableViewCell: UITableViewCell {
    // MARK: - Labels
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
