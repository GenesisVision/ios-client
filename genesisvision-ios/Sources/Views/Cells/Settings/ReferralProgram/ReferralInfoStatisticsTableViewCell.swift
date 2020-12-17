//
//  ReferralInfoStatisticsTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct ReferralInfoStatisticsTableViewCellViewModel {
    let partnerDetails: PartnershipDetails
}

extension ReferralInfoStatisticsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReferralInfoStatisticsTableViewCell) {
        
        if let total1 = partnerDetails.totalReferralsL1?.toString() {
            cell.friendsLevel1Value.text = total1
        }
        
        if let total2 = partnerDetails.totalReferralsL2?.toString() {
            cell.friendsLevel2Value.text = total2
        }
        
        if let total = partnerDetails.totalAmount?.toString() {
            cell.totalValue.text = total + " " + selectedPlatformCurrency
        }
    }
}

class ReferralInfoStatisticsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: LargeTitleLabel! {
        didSet {
            titleLabel.text = "Statistics"
        }
    }
    
    @IBOutlet weak var friendsLevel1Title: SubtitleLabel! {
        didSet {
            friendsLevel1Title.font = UIFont.getFont(.regular, size: 14.0)
            friendsLevel1Title.text = "Referral Friends Level 1"
        }
    }
    
    @IBOutlet weak var friendsLevel1Value: TitleLabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var friendsLevel2Title: SubtitleLabel! {
        didSet {
            friendsLevel2Title.font = UIFont.getFont(.regular, size: 14.0)
            friendsLevel2Title.text = "Referral Friends Level 2"
        }
    }
    
    @IBOutlet weak var friendsLevel2Value: TitleLabel! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var totalTitle: SubtitleLabel! {
        didSet {
            totalTitle.text = "Total rewards"
        }
    }
    @IBOutlet weak var totalValue: TitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
