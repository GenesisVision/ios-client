//
//  ProgramTradesTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramTradesTableViewCell: UITableViewCell {

    // MARK: - Labels
    @IBOutlet weak var entryImageView: UIImageView! {
        didSet {
            entryImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var symbolLabel: TitleLabel! {
        didSet {
            symbolLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet weak var directionLabel: SubtitleLabel!
    
    @IBOutlet weak var balanceLabel: TitleLabel! {
        didSet {
            balanceLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet weak var profitLabel: SubtitleLabel! {
        didSet {
            profitLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
