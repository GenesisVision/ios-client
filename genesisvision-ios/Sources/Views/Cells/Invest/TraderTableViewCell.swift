//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class TraderTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet var profileImageView: ProfileImageView!
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.addBorder(withBorderWidth: 1.0, color: UIColor.primary)
        }
    }
    
    @IBOutlet var depositLabel: UILabel!
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var weeksLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    
    @IBOutlet var depositValueLabel: UILabel!
    @IBOutlet var tradesValueLabel: UILabel!
    @IBOutlet var weeksValueLabel: UILabel!
    @IBOutlet var profitValueLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.background
    }
}
