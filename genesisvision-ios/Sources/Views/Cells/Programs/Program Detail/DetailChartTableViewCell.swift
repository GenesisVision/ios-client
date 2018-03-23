//
//  DetailChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class DetailChartTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.NavBar.grayBackground
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.NavBar.background
        contentView.backgroundColor = UIColor.NavBar.grayBackground
        selectionStyle = .none
    }
    
}
