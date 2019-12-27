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
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var managerImageView: UIImageView! {
        didSet {
            managerImageView.roundCorners()
            managerImageView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var managerNameLabel: UILabel! {
        didSet {
            managerNameLabel.textColor = UIColor.Cell.title
            managerNameLabel.font = UIFont.getFont(.semibold, size: 14.0)
            managerNameLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = UIColor.Cell.subtitle
            dateLabel.font = UIFont.getFont(.semibold, size: 12.0)
            dateLabel.isUserInteractionEnabled = false
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

class DetailTradingAccountTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: SubtitleLabel!
    
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
