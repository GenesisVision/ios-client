//
//  NotificationListTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct NotificationListTableViewCellViewModel {
    let notification: NotificationViewModel
}

extension NotificationListTableViewCellViewModel: CellViewModel {
    func setup(on cell: NotificationListTableViewCell) {

        if let type = NotificationType(rawValue: notification.type ?? "") {
            switch type {
            case .profile2FA:
                cell.iconImageView.image = #imageLiteral(resourceName: "icon_notification_user")
            default:
                cell.iconImageView.image = #imageLiteral(resourceName: "icon_notification_star")
            }
        }
        
        if let title = notification.text {
            cell.titleLabel.text = title
        }
        
        if let isUnread = notification.isUnread {
            cell.unreadView.isHidden = !isUnread
        }
        
        if let date = notification.date {
            cell.dateLabel.text = date.onlyTimeFormatString
        }
    }
}
