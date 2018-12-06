//
//  RatingTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 04/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class RatingTableHeaderView: UITableViewHeaderFooterView {
    // MARK: - Outlets
    @IBOutlet weak var programsTotalCountTitleLabel: SubtitleLabel!
    @IBOutlet weak var programsTotalCountValueLabel: TitleLabel!
    
    @IBOutlet weak var quotaTitleLabel: SubtitleLabel!
    @IBOutlet weak var quotaValueLabel: TitleLabel!
    
    @IBOutlet weak var targetProfitTitleLabel: SubtitleLabel!
    @IBOutlet weak var targetProfitValueLabel: TitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    func configure(_ levelUpData: LevelUpData) {
        programsTotalCountTitleLabel.text = "Programs"
        if let total = levelUpData.total {
            programsTotalCountValueLabel.text = total.toString()
        }
        
        quotaTitleLabel.text = "Quota"
        if let quota = levelUpData.quota {
            quotaValueLabel.text = quota.toString()
        }
        
        targetProfitTitleLabel.text = "Target profit"
        if let targetProfit = levelUpData.targetProfit {
            targetProfitValueLabel.text = targetProfit.rounded(withType: .undefined).toString() + "%"
            
            targetProfitValueLabel.textColor = targetProfit == 0 ? UIColor.Cell.title : targetProfit > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
    }
}
