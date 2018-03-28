//
//  DashboardHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardHeaderTableViewCell: UITableViewCell {

    // MARK: - Labels
    @IBOutlet var profitFromProgramsLabel: UILabel! {
        didSet {
            profitFromProgramsLabel.textColor = UIColor.Header.darkTitle
        }
    }
    
    @IBOutlet var investedAmountLabel: UILabel! {
        didSet {
            investedAmountLabel.textColor = UIColor.Header.darkTitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
}
