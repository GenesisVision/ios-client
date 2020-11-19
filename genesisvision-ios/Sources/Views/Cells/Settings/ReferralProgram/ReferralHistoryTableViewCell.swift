//
//  ReferralHistoryTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct ReferralHistoryTableViewCellViewModel {
    let rewardDetails: RewardDetails
}

extension ReferralHistoryTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReferralHistoryTableViewCell) {
        if let date = rewardDetails.date {
            cell.dateLabel.text = date.dateAndTimeToString()
        }
        
        if let currency = rewardDetails.currency, let amount = rewardDetails.amount {
            cell.rewardLabel.text = amount.toString() + " " + currency.rawValue
        }
    }
}

class ReferralHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    @IBOutlet weak var rewardLabel: TitleLabel!
    
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
