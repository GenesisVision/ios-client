//
//  DetailChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts
import TTSegmentedControl

protocol DetailChartTableViewCellProtocol: class {
    func showFullChartDidPressed()
}

class DetailChartTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: DetailChartTableViewCellProtocol?
    
    // MARK: - Views
    @IBOutlet var viewForChartView: UIView!
    @IBOutlet var segmentedControl: TTSegmentedControl!
    
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
        
        segmentedControl.itemTitles = ["day", "week", "month", "year"]
        segmentedControl.backgroundColor = UIColor.NavBar.grayBackground
        segmentedControl.allowChangeThumbWidth = false
        segmentedControl.didSelectItemWith = { (index, title) -> () in
            print("Selected item \(index)")
        }
    }
    
    // MARK: - Private methods
    @IBAction func showFullChart(_ sender: UIButton) {
        delegate?.showFullChartDidPressed()
    }
}
