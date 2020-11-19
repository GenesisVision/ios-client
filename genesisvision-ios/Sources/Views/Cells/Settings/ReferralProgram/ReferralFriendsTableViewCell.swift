//
//  ReferralFriendsTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct ReferralFriendsTableViewCellViewModel {
    let referralFriend: ReferralFriend
}

extension ReferralFriendsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReferralFriendsTableViewCell) {
        if let date = referralFriend.date?.dateAndTimeToString() {
            cell.dateLabel.text = date
        }
        
        if let email = referralFriend.emailMask {
            cell.emailLabel.text = email
        }
    }
}

class ReferralFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    @IBOutlet weak var emailLabel: TitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
