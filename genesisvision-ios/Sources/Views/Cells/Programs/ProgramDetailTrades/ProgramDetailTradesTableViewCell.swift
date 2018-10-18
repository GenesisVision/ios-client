//
//  ProgramDetailTradesTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailTradesTableViewCell: PlateTableViewCell {

    // MARK: - Labels
    @IBOutlet var entryImageView: UIImageView! {
        didSet {
            entryImageView.roundCorners()
        }
    }
    
    @IBOutlet var symbolLabel: TitleLabel! {
        didSet {
            symbolLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet var directionLabel: SubtitleLabel!
    
    @IBOutlet var balanceLabel: TitleLabel! {
        didSet {
            balanceLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var profitLabel: SubtitleLabel! {
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
