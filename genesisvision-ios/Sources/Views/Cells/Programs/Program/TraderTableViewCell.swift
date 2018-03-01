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
    @IBOutlet var programLogoImageView: ProfileImageView!
    @IBOutlet var programDetailsView: ProgramDetailsForTableViewCellView!
    
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.addBorder(withBorderWidth: 1.0, color: UIColor.primary)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
    }
}
