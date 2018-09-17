//
//  DashboardInRequestsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 13/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardInRequestsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundWithBorder(2.0, color: UIColor.Cell.bg)
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.font = UIFont.getFont(.bold, size: 27.0)
            balanceValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.regular, size: 13.0)
            dateLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
