//
//  PeriodHistoryTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class PeriodHistoryTableViewCell: UITableViewCell {
    // MARK: - Labels
    @IBOutlet weak var periodLabel: TitleLabel!
    @IBOutlet weak var dateStartLabel: TitleLabel!
    @IBOutlet weak var dateFinishLabel: TitleLabel!
    @IBOutlet weak var balanceLabel: TitleLabel!
    @IBOutlet weak var profitLabel: TitleLabel!
    @IBOutlet weak var investorsLabel: TitleLabel!
    
    @IBOutlet weak var periodTitleLabel: SubtitleLabel!
    @IBOutlet weak var dateStartTitleLabel: SubtitleLabel!
    @IBOutlet weak var dateFinishTitleLabel: SubtitleLabel!
    @IBOutlet weak var balanceTitleLabel: SubtitleLabel!
    @IBOutlet weak var profitTitleLabel: SubtitleLabel!
    @IBOutlet weak var investorsTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor.Cell.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
