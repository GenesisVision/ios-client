//
//  SignalTradingLogTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 17/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class SignalTradingLogTableViewCell: UITableViewCell {
    // MARK: - Views
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}

