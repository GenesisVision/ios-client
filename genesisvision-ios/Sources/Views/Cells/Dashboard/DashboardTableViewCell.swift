//
//  DashboardTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    var investmentProgramId: String = ""
    var investedTokens: Double = 0.0
    
    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.Background.main
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var programTitleLabel: UILabel!
    @IBOutlet var managerNameLabel: UILabel!
    
    @IBOutlet var tokensCountValueLabel: UILabel!
    @IBOutlet var tokensCountTitleLabel: UILabel!
    
    @IBOutlet var profitValueLabel: UILabel!
    @IBOutlet var profitTitleLabel: UILabel!
    
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Background.main
    }
}
