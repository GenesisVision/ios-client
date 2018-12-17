//
//  InRequestsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 13/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class InRequestsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var statusLabel: SubtitleLabel! {
        didSet {
            statusLabel.font = UIFont.getFont(.regular, size: 12.0)
            statusLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet var amountValueLabel: TitleLabel! {
        didSet {
            amountValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
            amountValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var dateLabel: SubtitleLabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.regular, size: 12.0)
            dateLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Cell.bg
        backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        
        selectionStyle = .none
    }
}
