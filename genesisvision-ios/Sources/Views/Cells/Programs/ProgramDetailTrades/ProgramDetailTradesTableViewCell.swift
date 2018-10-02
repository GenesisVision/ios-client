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
    
    @IBOutlet var symbolLabel: UILabel! {
        didSet {
            symbolLabel.textColor = UIColor.Cell.title
            symbolLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet var directionLabel: UILabel! {
        didSet {
            directionLabel.textColor = UIColor.Cell.subtitle
            directionLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var balanceLabel: UILabel! {
        didSet {
            balanceLabel.textColor = UIColor.Cell.title
            balanceLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var profitLabel: UILabel! {
        didSet {
            profitLabel.textColor = UIColor.Cell.greenTitle
            profitLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Cell.bg
        selectionStyle = .none
    }
}
