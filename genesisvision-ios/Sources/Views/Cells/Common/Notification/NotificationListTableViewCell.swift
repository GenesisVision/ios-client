//
//  NotificationListTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
            iconImageView.image = #imageLiteral(resourceName: "icon_notification_star")
        }
    }
    
    @IBOutlet weak var unreadView: UIView! {
        didSet {
            unreadView.roundCorners()
            unreadView.backgroundColor = UIColor.Cell.redTitle
            unreadView.isHidden = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.semibold, size: 12.0)
            dateLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var detailButton: UIButton! {
        didSet {
            detailButton.isHidden = true
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
