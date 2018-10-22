//
//  DetailManagerTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DetailManagerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var managerImageView: UIImageView! {
        didSet {
            managerImageView.roundCorners()
        }
    }
    @IBOutlet var managerNameLabel: UILabel! {
        didSet {
            managerNameLabel.textColor = UIColor.Cell.title
            managerNameLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = UIColor.Cell.subtitle
            dateLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
