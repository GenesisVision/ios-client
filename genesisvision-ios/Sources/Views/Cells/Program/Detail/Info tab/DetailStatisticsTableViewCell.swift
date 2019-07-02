//
//  DetailStatisticsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class DetailStatisticsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var periodLabel: TitleLabel!
    @IBOutlet weak var ageLabel: TitleLabel!
    @IBOutlet weak var wpdLabel: TitleLabel!
    @IBOutlet weak var investmentScaleLabel: TitleLabel!
    @IBOutlet weak var leverageLabel: TitleLabel!
    @IBOutlet weak var volumeLabel: TitleLabel!
    @IBOutlet weak var brokerLogo: UIImageView!
    
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
