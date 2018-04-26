//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class TraderTableViewCell: PlateTableViewCell {
    
    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    @IBOutlet var programDetailsView: ProgramDetailsForTableViewCellView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackedProgressView: StackedProgressView!
    @IBOutlet var viewForChartView: UIView!
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
    @IBOutlet var currencyLabel: CurrencyLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

//        contentView.backgroundColor = UIColor.Background.main
    }
    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//
//        contentView.backgroundColor = highlighted ? UIColor.Background.highlightedCell : UIColor.Background.main
//    }
}
